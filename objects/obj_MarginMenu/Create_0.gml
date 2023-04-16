{
	event_inherited();
	active = true;
	with(MenuItem_DropDown_Create(16, game_height/8, "Dropdown Test")){
		// For dropdown menus, store a 2d array of values storing the Display value of dropdown items,
		//   and a function associated with them. When clicking on the menus, it will create a list of
		//   buttons in sequence based on the dropdown menu type (0 = hori, 1 = vert)
		menu_add(menutype.button,"Default Test", function(){trace("SKROOOOOOOOOONK")});
		menu_add(menutype.button,"Default Test 2", function(){trace("NYA")});
		menu_add_ext(
			menutype.dropdown,
			"Dropdown Test 1", 
			function(){trace("NYA")},
			[
				[menutype.button, "Dropdown Subtest 1", function(){trace("HOLY FUCK")}],
				[menutype.button, "Dropdown Subtest 2", function(){trace("HOLY FUCK")}],
				[menutype.button, "Dropdown Subtest 2", function(){trace("HOLY FUCK")}],
				[menutype.button, "Dropdown Subtest 2", function(){trace("HOLY FUCK")}],
				[menutype.button, "Dropdown Subtest 2", function(){trace("HOLY FUCK")}],
				[menutype.button, "Dropdown Subtest 2", function(){trace("HOLY FUCK")}],
				[menutype.button, "Dropdown Subtest 2", function(){trace("HOLY FUCK")}],
				[menutype.button, "Dropdown Subtest 2", function(){trace("HOLY FUCK")}],
				[menutype.button, "Dropdown Subtest 2", function(){trace("HOLY FUCK")}],
				[menutype.button, "Dropdown Subtest 2", function(){trace("HOLY FUCK")}],
				[menutype.button, "Dropdown Subtest 2", function(){trace("HOLY FUCK")}],
				[menutype.button, "Dropdown Subtest 2", function(){trace("HOLY FUCK")}],
			]
		);
	}
	
	with(MenuItem_DropDown_Create(128, game_height/8, "SaveData")){
		var _ar = [];
		var _ar2 = [];
		// Write code for scanning files in a directory here
		var _files = ["save01.dat", "save02.dat", "save03.dat", "save04.dat"];
		for(var i = 0;i<array_length(_files);i++){
			_ar[@i] = [menutype.button, _files[i], function(){SaveGame()}];	
			_ar2[@i] = [menutype.button, _files[i], function(){LoadGame()}];
		}
		menu_add_ext(
			menutype.dropdown,
			"Save File",
			function(){trace("NYA")},
			_ar
		);
		menu_add_ext(
			menutype.dropdown,
			"Load File",
			function(){trace("NYA")},
			_ar2
		);
		menu_add_ext(
			menutype.slider,
			"Brightness I guess",
			[obj_Camera, "bcs_brightness_goal"],
			0,
			32,
			3,
			0,
			1,
		);
		menu_add_ext(
			menutype.slider,
			"Contrast I guess",
			[obj_Camera, "bcs_contrast_goal"],
			0,
			32,
			3,
			-0.5,
			2,
		);
			
	}
}