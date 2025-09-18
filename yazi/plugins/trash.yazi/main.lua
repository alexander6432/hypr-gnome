local restore_file = ya.sync(function()
	local hovered = cx.active.current.hovered
	if not hovered then
		return "Nada seleccionado"
	end

	local name = hovered.name
	local home = os.getenv("HOME")
	local trashinfo_path = home .. "/.local/share/Trash/info/" .. name .. ".trashinfo"
	local trashed_file_path = home .. "/.local/share/Trash/files/" .. name

	-- Leer el path original desde el archivo .trashinfo
	local file = io.open(trashinfo_path, "r")
	if not file then
		return "No se encontró .trashinfo"
	end

	local original_path
	for line in file:lines() do
		original_path = line:match("^Path=(.+)")
		if original_path then
			break
		end
	end
	file:close()

	if not original_path then
		return "No se encontró el path original"
	end

	-- Crear directorios padre si no existen
	os.execute('mkdir -p "' .. original_path:match("(.*/)") .. '"')

	-- Mover el archivo
	local success = os.rename(trashed_file_path, original_path)
	if success then
		-- Eliminar el .trashinfo correspondiente
		os.remove(trashinfo_path)
		return "Restaurado: " .. original_path
	else
		return "Error al mover el archivo a su ubicación original"
	end
end)

return {
	entry = function()
		local msg = restore_file()
		ya.notify({
			title = "Restaurar archivo",
			content = msg,
			timeout = 6,
			level = "info",
		})
	end,
}
