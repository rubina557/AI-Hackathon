# Agent 2: Bounding Box Geospatial Discovery
- Read location_query from Agent 1 and parse it into absolute coordinate nodes (Hyder Chowk = Lat 25.3931, Lng 68.3722).
- Filter entries in `mock_providers.json` by matching service categories.
- Calculate radial distances using the Haversine equation. Set an initial lookup radius parameter of 15km. If results are less than 3, scale the boundary up to 25km automatically.
