local BD = require("ui/bidi")
local ConfirmBox = require("ui/widget/confirmbox")
local DocSettings = require("docsettings")
local InfoMessage = require("ui/widget/infomessage")
local ReadCollection = require("readcollection")
local ReadHistory = require("readhistory")
local UIManager = require("ui/uimanager")
local WidgetContainer = require("ui/widget/container/widgetcontainer")
local filemanagerutil = require("apps/filemanager/filemanagerutil")
local ffiUtil = require("ffi/util")
local lfs = require("libs/libkoreader-lfs")
local _ = require("gettext")
local T = ffiUtil.template

local SETTINGS_KEY = "moveto_target_dir"

local MoveTo = WidgetContainer:extend{
    name = "moveto",
    is_doc_only = false,
}

local function getFileManager()
    return require("apps/filemanager/filemanager")
end

function MoveTo:init()
    if self.ui and self.ui.menu then
        self.ui.menu:registerToMainMenu(self)
    end
    self:registerFileDialogButtons()
end

function MoveTo:getTargetDir()
    local path = G_reader_settings:readSetting(SETTINGS_KEY)
    if not path or path == "" then
        return nil
    end
    path = ffiUtil.realpath(path) or path
    if lfs.attributes(path, "mode") ~= "directory" then
        return nil
    end
    return path
end

function MoveTo:getTargetDirLabel()
    local path = self:getTargetDir()
    if not path then
        return _("non défini")
    end
    return BD.dirpath(filemanagerutil.abbreviate(path))
end

function MoveTo:getTargetDirBasename()
    local path = self:getTargetDir()
    if not path then
        return nil
    end
    return path:match("([^/]+)/?$")
end

function MoveTo:chooseTargetDir()
    local current = self:getTargetDir()
        or G_reader_settings:readSetting("home_dir")
        or G_reader_settings:readSetting("lastdir")
        or filemanagerutil.getDefaultDir()
    local PathChooser = require("ui/widget/pathchooser")
    UIManager:show(PathChooser:new{
        select_directory = true,
        select_file = false,
        path = current,
        onConfirm = function(path)
            path = ffiUtil.realpath(path) or path
            G_reader_settings:saveSetting(SETTINGS_KEY, path)
            UIManager:show(InfoMessage:new{
                text = T(_("Dossier cible :\n%1"), BD.dirpath(path)),
                timeout = 2,
            })
        end,
    })
end

function MoveTo:addToMainMenu(menu_items)
    menu_items.moveto = {
        text = _("Move to"),
        -- Must be an existing submenu id (tools, search, setting, …).
        -- A missing hint crashes MenuSorter when opening the main menu.
        sorting_hint = "tools",
        sub_item_table_func = function()
            return {
                {
                    text_func = function()
                        return T(_("Dossier cible : %1"), self:getTargetDirLabel())
                    end,
                    keep_menu_open = true,
                    callback = function()
                        self:chooseTargetDir()
                    end,
                },
                {
                    text = _("Choisir le dossier…"),
                    keep_menu_open = true,
                    callback = function()
                        self:chooseTargetDir()
                    end,
                },
            }
        end,
    }
end

function MoveTo:closeFileDialog()
    local FileManager = getFileManager()
    if not FileManager.instance then
        return
    end
    local menu = FileManager.getMenuInstance()
    if menu and menu.file_dialog then
        UIManager:close(menu.file_dialog)
        menu.file_dialog = nil
    end
end

function MoveTo:isAlreadyInTarget(file, target_dir)
    local parent = ffiUtil.realpath(ffiUtil.dirname(file))
    return parent == target_dir
end

function MoveTo:doMove(orig_file, dest_path, is_file)
    local FileManager = getFileManager()
    local fm = FileManager.instance
    if not fm then
        UIManager:show(InfoMessage:new{
            text = _("Navigateur de fichiers indisponible."),
            icon = "notice-warning",
        })
        return
    end

    local orig_name = ffiUtil.basename(orig_file)
    local dest_file = ffiUtil.joinPath(dest_path, orig_name)

    if orig_file == dest_file or orig_file == dest_path then
        return
    end

    local function performMove()
        local ok = fm:moveFile(orig_file, dest_path)
        if ok then
            if is_file then
                DocSettings.updateLocation(orig_file, dest_file, false)
                ReadHistory:updateItem(orig_file, dest_file)
                ReadCollection:updateItem(orig_file, dest_file)
            else
                ReadHistory:updateItemsByPath(orig_file, dest_file)
                ReadCollection:updateItemsByPath(orig_file, dest_file)
                if fm.folder_shortcuts then
                    fm.folder_shortcuts:updateItemsByPath(orig_file, dest_file)
                end
            end
            fm:onRefresh()
            UIManager:show(InfoMessage:new{
                text = T(_("Envoyé vers :\n%1"), BD.dirpath(dest_path)),
                timeout = 2,
            })
        else
            UIManager:show(InfoMessage:new{
                text = T(_("Échec du déplacement :\n%1\nvers :\n%2"),
                    BD.filepath(orig_name), BD.dirpath(dest_path)),
                icon = "notice-warning",
            })
        end
    end

    local mode_dest = lfs.attributes(dest_file, "mode")
    if mode_dest then
        local can_overwrite = (mode_dest == "file") == is_file
        local text = is_file
            and T(_("Le fichier existe déjà :\n%1"), BD.filename(orig_name))
            or T(_("Le dossier existe déjà :\n%1"), BD.directory(orig_name))
        if can_overwrite then
            UIManager:show(ConfirmBox:new{
                text = text,
                ok_text = _("Écraser"),
                ok_callback = performMove,
            })
        else
            UIManager:show(InfoMessage:new{
                text = text,
                icon = "notice-warning",
            })
        end
    else
        performMove()
    end
end

function MoveTo:movePathToTarget(file, is_file)
    local target_dir = self:getTargetDir()
    if not target_dir then
        UIManager:show(InfoMessage:new{
            text = _("Aucun dossier cible. Réglez-le dans les paramètres du plugin Move to."),
            icon = "notice-warning",
        })
        return
    end

    local orig_file = ffiUtil.realpath(file) or file
    if self:isAlreadyInTarget(orig_file, target_dir) then
        UIManager:show(InfoMessage:new{
            text = _("Déjà dans le dossier cible."),
            timeout = 2,
        })
        return
    end

    local name = ffiUtil.basename(orig_file)
    local folder_label = self:getTargetDirBasename() or target_dir
    UIManager:show(ConfirmBox:new{
        text = T(_("Envoyer « %1 » vers « %2 » ?"), name, folder_label),
        ok_text = _("Envoyer"),
        ok_callback = function()
            self:doMove(orig_file, target_dir, is_file)
        end,
    })
end

function MoveTo:registerFileDialogButtons()
    local FileManager = getFileManager()
    if type(FileManager.addFileDialogButtons) ~= "function" then
        return
    end
    FileManager:addFileDialogButtons("moveto", function(file, is_file, _book_props)
        local target_dir = self:getTargetDir()
        local basename = self:getTargetDirBasename()
        local button_text = basename
            and T(_("Envoyer vers « %1 »"), basename)
            or _("Envoyer vers…")

        local enabled = true
        if target_dir then
            local orig = ffiUtil.realpath(file) or file
            if self:isAlreadyInTarget(orig, target_dir) or orig == target_dir then
                enabled = false
            end
        end

        return {
            {
                text = button_text,
                enabled = enabled,
                callback = function()
                    self:closeFileDialog()
                    if not target_dir then
                        UIManager:show(InfoMessage:new{
                            text = _("Aucun dossier cible. Réglez-le dans les paramètres du plugin Move to."),
                            icon = "notice-warning",
                        })
                        return
                    end
                    self:movePathToTarget(file, is_file)
                end,
            },
        }
    end)
end

return MoveTo
