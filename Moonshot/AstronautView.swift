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
            } else {
                fatalError("Missing \(mission)")
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
                        ForEach(self.flownMissions) { crew in
                            HStack {
                                Image(crew.image)
                                    .resizable()
                                    .frame(width: 44, height: 44)
                                    .scaledToFit()
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading) {
                                    Text(crew.displayName)
                                    
                                    Text(crew.formattedLaunchDate)
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        AstronautView(astronaut: astronauts[0])
    }
}
