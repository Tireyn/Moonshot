//
//  AstronautView.swift
//  Moonshot
//
//  Created by Sam on 2019-12-09.
//  Copyright © 2019 Sailfish Studios. All rights reserved.
//

import SwiftUI

struct AstronautView: View {

    let astronaut: Astronaut
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    var flownMissions: [Mission] {
        var listOfMissions = [Mission]()
        
        for mission in missions {
            if let _ = mission.crew.first(where: { $0.name == self.astronaut.id }) {
                listOfMissions.append(mission)
            }
        }
        
        return listOfMissions
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical) {
                VStack {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                    
                    Text(self.astronaut.description)
                        .padding()
                    
                    Section(header: Text("Missions Flown")) {
                        ForEach(self.flownMissions) { mission in
                            HStack {
                                Image(mission.image)
                                    .resizable()
                                    .frame(width: 44, height: 44)
                                    .scaledToFit()
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading) {
                                    Text(mission.displayName)
                                    
                                    Text(mission.formattedLaunchDate)
                                        .font(.caption)
                                }
                            }
                            .scaledToFit()
                        }
                    }
                }
            }
        }
    }
    
    init(astronaut: Astronaut) {
        self.astronaut = astronaut
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        AstronautView(astronaut: astronauts[7])
    }
}
