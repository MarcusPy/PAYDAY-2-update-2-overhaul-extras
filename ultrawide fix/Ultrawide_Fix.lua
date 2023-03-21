if RequiredScript == "core/lib/managers/viewport/coreviewportmanager" then
    core:module("CoreViewportManager")

    function ViewportManager:get_safe_rect()
        return {
            x = 3.2 * 0.01,
            y = 3.2 * 0.01,
            width = 1 - 3.2 * 0.01 * 2,
            height = 1 - 3.2 * 0.01 * 2
        }
    end
end

if RequiredScript == "core/lib/managers/coreguidatamanager" then
    if core then
        core:module("CoreGuiDataManager")
    end

    function GuiDataManager:get_base_res()
        return self._base_res.x, self._base_res.y
    end

    function GuiDataManager:scaled_size()
        local w = math.round(self:_get_safe_rect().width * self._base_res.x)
        local h = math.round(self:_get_safe_rect().height * self._base_res.y)

        return {
            x = 0,
            y = 0,
            width = w,
            height = h
        }
    end

    function GuiDataManager:_setup_workspace_data()
        local res = self._static_resolution or RenderSettings.resolution
        local aspect = res.x / res.y
        self._base_res = {
            x = 720 * aspect * 1,
            y = 720 * 1
        }

        self._saferect_data = {}
        self._corner_saferect_data = {}
        self._fullrect_data = {}
        local safe_rect = self:_get_safe_rect_pixels()
        local scaled_size = self:scaled_size()
        local res = self._static_resolution or RenderSettings.resolution
        local w = scaled_size.width
        local h = scaled_size.height
        local sh = math.min(safe_rect.height, safe_rect.width / (w / h))
        local sw = math.min(safe_rect.width, safe_rect.height * w / h)
        local x = res.x / 2 - sh * w / h / 2
        local y = res.y / 2 - sw / (w / h) / 2
        self._safe_x = x
        self._safe_y = y
        self._saferect_data.w = w
        self._saferect_data.h = h
        self._saferect_data.width = self._saferect_data.w
        self._saferect_data.height = self._saferect_data.h
        self._saferect_data.x = x
        self._saferect_data.y = y
        self._saferect_data.on_screen_width = sw
        local h_c = w / (safe_rect.width / safe_rect.height)
        h = math.max(h, h_c)
        local w_c = h_c / h
        w = math.max(w, w / w_c)
        self._corner_saferect_data.w = w
        self._corner_saferect_data.h = h
        self._corner_saferect_data.width = self._corner_saferect_data.w
        self._corner_saferect_data.height = self._corner_saferect_data.h
        self._corner_saferect_data.x = safe_rect.x
        self._corner_saferect_data.y = safe_rect.y
        self._corner_saferect_data.on_screen_width = safe_rect.width
        sh = self._base_res.x / self:_aspect_ratio()
        h = math.max(self._base_res.y, sh)
        sw = sh / h
        w = math.max(self._base_res.x, self._base_res.x / sw)
        self._fullrect_data.w = w
        self._fullrect_data.h = h
        self._fullrect_data.width = self._fullrect_data.w
        self._fullrect_data.height = self._fullrect_data.h
        self._fullrect_data.x = 0
        self._fullrect_data.y = 0
        self._fullrect_data.on_screen_width = res.x
        self._fullrect_data.convert_x = math.floor((w - scaled_size.width) / 2)
        self._fullrect_data.convert_y = math.floor((h - scaled_size.height) / 2)
        self._fullrect_data.corner_convert_x =
            math.floor((self._fullrect_data.width - self._corner_saferect_data.width) / 2)
        self._fullrect_data.corner_convert_y =
            math.floor((self._fullrect_data.height - self._corner_saferect_data.height) / 2)

        self._fullrect_16_9_data = self._fullrect_data
        self._fullrect_1280_data = self._fullrect_data
        self._corner_saferect_1280_data = self._corner_saferect_data
    end
end

if RequiredScript == "lib/managers/mousepointermanager" then
    MousePointerManager.convert_1280_mouse_pos = MousePointerManager.convert_fullscreen_mouse_pos
    MousePointerManager.convert_fullscreen_16_9_mouse_pos = MousePointerManager.convert_fullscreen_mouse_pos
end