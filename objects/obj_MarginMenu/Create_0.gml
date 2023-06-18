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
		var i = 0;
		var fileName = file_find_first(working_directory + "/save/" + "*.dat",fa_directory);
		var fArray = [];
		while(fileName != ""){
			fArray[i] = fileName;
			fileName = file_find_next();
			i += 1;
		}
		file_find_close();
		if array_length(fArray) == 0{
			fArray = ["save0.dat"];	
		}
		
		// Stuff to construct the arrays above
		// Stuff to construct the buttons below
		
		for(var i = 0;i<array_length(fArray);i++){
			_ar[@i] = [menutype.button, fArray[i], "SaveGame display_name"];	
			_ar2[@i] = [menutype.button, fArray[i], "LoadGame display_name"];
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
			menutype.button,
			"Add Save File",
			function(){trace(SaveGame())},
		);
	}
}