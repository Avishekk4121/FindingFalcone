 Finding Falcone — iOS App                                                     
                                                                                
  Finding Falcone is a native iOS application built with SwiftUI that brings the
   https://www.geektrust.com/coding/detailed/space problem to life as an        
  interactive mobile experience. King Shan must find his lost love Falcone
  across 6 planets using a fleet of space vehicles. Your mission: choose the    
  right 4 planets to search and the right vehicles to get there.              

  Overview
          
  The app integrates with the https://findfalcone.geektrust.com to fetch real
  planet and vehicle data, validate selections, and determine whether Falcone   
  was found. Users configure 4 search destinations — each with a target planet
  and an assigned vehicle — then launch the search to get an instant result.    
                                                                              
  Features
                                                                                
  - Live data — Planets and vehicles are fetched from the GeekTrust API on
  launch                                                                        
  - Smart filtering — Only planets not already selected elsewhere appear in each
   destination's dropdown; vehicles are filtered by range (must reach the target
   planet) and available count (can't exceed fleet limits)                    
  - Real-time time tracking — Total travel time updates as you make selections, 
  calculated as distance / speed per destination                                
  - Mission result screen — Clear success or failure feedback, showing which
  planet Falcone was found on and total time taken                              
  - Start again — Reset all selections and retry from scratch                 
                                                                                
  ---                                                                         
  Architecture
              
  The project follows MVVM with a protocol-based service layer:
                                                                                
  FindingFalcone/
  ├── Model/                                                                    
  │   ├── Planet.swift          # Planet with name + distance                 
  │   ├── Vehicle.swift         # Vehicle with speed, range, fleet count        
  │   ├── Destination.swift     # Pair of (Planet?, Vehicle?) per search slot 
  │   └── FindResponse.swift    # API response: status + planet name            
  │                                                                             
  ├── Services/                                                                 
  │   ├── FalconeAPIProtocol.swift   # Abstraction for testability              
  │   ├── ApiService.swift           # Concrete URLSession implementation       
  │   └── APIError.swift             # Typed error cases                        
  │                                                                             
  ├── ViewModel/                                                                
  │   └── FalconeViewModel.swift     # @MainActor ObservableObject, all logic   
  │                                                                             
  └── Views/
      ├── AppHeader.swift        # Shared indigo header bar                     
      ├── SelectionView.swift    # Main screen: 4 destination cards + Find      
  button                                                                        
      └── ResultView.swift       # Success/failure result screen                
                                                                                
  Key design decisions                                                        

  ┌────────────────────────┬────────────────────────────────────────────────┐   
  │        Decision        │                   Rationale                    │ 
  ├────────────────────────┼────────────────────────────────────────────────┤   
  │                        │ Decouples the ViewModel from the concrete      │ 
  │ FalconeAPIProtocol     │ network layer, enabling easy unit testing with │ 
  │                        │  mock implementations                          │   
  ├────────────────────────┼────────────────────────────────────────────────┤ 
  │                        │ All network calls use Swift Concurrency;       │   
  │ async/await            │ planets and vehicles are fetched in parallel   │   
  │                        │ with async let                                 │ 
  ├────────────────────────┼────────────────────────────────────────────────┤   
  │ @MainActor on          │ All published state mutations happen on the    │   
  │ ViewModel              │ main thread without manual DispatchQueue.main  │
  │                        │ calls                                          │   
  ├────────────────────────┼────────────────────────────────────────────────┤ 
  │                        │ Keeps Views declarative and dumb — all         │   
  │ Planet/vehicle         │ constraint logic lives in                      │
  │ filtering in ViewModel │ availablePlanets(at:) and                      │   
  │                        │ availableVehicles(for:at:)                     │ 
  └────────────────────────┴────────────────────────────────────────────────┘

  ---
  API Integration
                 
  The app communicates with https://findfalcone.geektrust.com across four
  endpoints:                                                                    
   
  ┌───────────┬────────┬─────────────────────────────────────────────────────┐  
  │ Endpoint  │ Method │                       Purpose                       │
  ├───────────┼────────┼─────────────────────────────────────────────────────┤
  │ /planets  │ GET    │ Fetch all planets with distances                    │
  ├───────────┼────────┼─────────────────────────────────────────────────────┤
  │ /vehicles │ GET    │ Fetch all vehicles with speed, range, and fleet     │  
  │           │        │ count                                               │
  ├───────────┼────────┼─────────────────────────────────────────────────────┤  
  │ /token    │ POST   │ Obtain a one-time auth token for the find request   │
  ├───────────┼────────┼─────────────────────────────────────────────────────┤  
  │ /find     │ POST   │ Submit planet + vehicle selections, receive         │
  │           │        │ success/failure                                     │  
  └───────────┴────────┴─────────────────────────────────────────────────────┘
                                                                                
  The token is fetched fresh on every "Find Falcone" attempt — it is single-use 
  and not cached.
                                                                                
  ---                                                                         
  Requirements

  - iOS 16+
  - Xcode 15+
  - Swift 5.9+
  - Active internet connection (API calls required)                             
   
  ---                                                                           
  Getting Started                                                             
                                                                                
  1. Clone the repository
  2. Open FindingFalcone.xcodeproj in Xcode                                     
  3. Select a simulator or device running iOS 16+                             
  4. Build and run (Cmd + R)                                                    
   
  No API keys or environment configuration needed — the GeekTrust API is open.  
                                                                              
  ---
  How to Play

  1. The app loads planets and vehicles automatically on launch
  2. For each of the 4 destinations, select a planet from the dropdown
  3. Once a planet is selected, choose a vehicle from the available options     
  (filtered by range and fleet availability)                                    
  4. Watch the Total Time counter update as you configure each destination      
  5. When all 4 destinations are complete, tap Find Falcone                     
  6. The result screen reveals whether your mission succeeded — and on which    
  planet Falcone was hiding                                                     
                                                                                
  ---                                                                           
  Project Structure Notes                                                     
                                                                                
  - SelectionView is the app's root view, rendered directly from
  FindingFalconeApp                                                             
  - DestinationCard is a private sub-view within SelectionView, responsible for
  rendering one planet+vehicle selection slot                                   
  - FalconeViewModel owns a single array of 4 Destination values; all selection
  state flows through this array                                                
  - Resetting the app calls vm.reset() which clears all destinations and      
  dismisses the result screen                                                   
                                                                              
  ---                                                                           
  Built as a GeekTrust coding challenge implementation in SwiftUI. 
