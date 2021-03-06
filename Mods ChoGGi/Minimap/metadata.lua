return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library v6.4",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
	"title", "Minimap v0.5",
	"version", 5,
	"saved", 1551787200,
	"image", "Preview.png",
	"id", "ChoGGi_Minimap",
	"steam_id", "1571476937",
	"pops_desktop_uuid", "3e0f7458-9638-43bd-8228-26e38da5df70",
	"author", "ChoGGi",
	"lua_revision", LuaRevision,
	"code", {
		"Code/Minimap.lua",
		"Code/Script.lua",
		"Code/ModConfig.lua",
	},
	"description", [[It's an image of the map you can click on to move the camera around (useful for setting transport routes).
This is an image, so click target isn't perfect.

For those of us using ultrawide the image doesn't work that well.
There's a Mod Config Reborn option to use my topography images instead:
https://steamcommunity.com/sharedfiles/filedetails/?id=1571465108

If the camera view gets messed up then zoom in and out a couple times to fix it.]],
})
