# AllTrails

**Overview**
- The project makes 3 types of api calls,
    1. To fetch nearby stores at launch
    2. To fetch search result
    3. Image(s) from url
- The restaurants can be viewed in either list view (tableview) or in map view 
- At the launch location is requested
- If permission is granted it fetches the nearby places right away and populates the view 
- Map view has pins that can change color on selection and deselections
- Selecting a map pin shows a custom annotation view
- Map view is zoomed/focused to where our pins are
- List view has option to mark restaurant as favorite and will remain favorite throughout even if we re-search 
-  We have z-position floating button that can switch views between the two
- Has unit testing
- Tested with dark and light mode
- Landscape and portrait

## Enhancements/Improvements
- Couple of things we can add into the project that aren't currently part of it
    1. Accessibility: Currently project doesn't support fully dynamic sizing and voiceovers but something that can be enhanced  
    2. Option to mark a place favorite remains in list view that can be added in annotation view as well so that favorite can be consist across the views
    3. Filter button can be provided where the list view filters and can perform sorting

---

## Contributors 

- Arun Kumar <arunkkumarr4@gmail.com>

---

## Licensed under the [MIT License](LICENSE)
