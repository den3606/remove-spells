local VALUES = dofile_once("mods/noita-remover/files/scripts/variables.lua")

function StringToNumber(str)
  local num = 0
  for i = 1, #str do
    local char = string.sub(str, i, i)
    num = num + string.byte(char)
  end
  return num
end

function NewID()
  local global_gui_id = tonumber(ModSettingGet(VALUES.GLOBAL_GUI_ID_KEY)) or 0
  if global_gui_id == 0 then
    global_gui_id = StringToNumber(VALUES.MOD_NAME)
  end

  global_gui_id = global_gui_id + 1
  ModSettingSet(VALUES.GLOBAL_GUI_ID_KEY, tostring(global_gui_id))
  return global_gui_id
end

-- HACK: 画像とボタンテキストを重ねて設置している
-- 各言語によってスペースの扱い勝ちが言うので、調整が必要
function GuiToggleImageButton(gui, image_id, button_id, icon_path, state_name, active_fn, deactive_fn)
  local w, h = GuiGetImageDimensions(gui, icon_path, 1)

  local blank = ''

  if GameTextGet("$current_language") == "English" then
    for i = 0, math.floor(w / 4) do
      blank = blank .. ' '
    end
  end
  if GameTextGet("$current_language") == "日本語" then
    for i = 0, math.floor(w / 2) do
      blank = blank .. ' '
    end
  end


  local is_active = ModSettingGet(state_name) or false

  if GuiButton(gui, button_id, 0, h / 4, blank) then
    is_active = not is_active

    -- graphic処理以外はButtonが押されたときのみ動作させる
    ModSettingSet(state_name, is_active)
    if is_active then
      active_fn()
    else
      deactive_fn()
    end
  end

  if is_active then
    GuiImage(gui, image_id, -w, 0, icon_path, 1, 1)
  else
    GuiImage(gui, image_id, -w, 0, icon_path, 0.3, 1)
  end
end