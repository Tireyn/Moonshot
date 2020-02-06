//
//  MissionView.swift
//  Moonshot
//
//  Created by Sam on 2019-12-09.
//  Copyright © 2019 Sailfish Studios. All rights reserved.
//

import SwiftUI

struct MissionView: View {
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    let mission: Mission
    let astronauts: [CrewMember]
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical) {
                VStack {
                    GeometryReader { imageGeo in
                        Image(self.mission.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: imageGeo.size.width, height: imageGeo.size.height)
                            .padding(.top, 10)
                            .scaleEffect(
                                self.missionImageScaleEffect(imageGeo.frame(in: .global), geo.frame(in: .global))
                            )
                    }
                    .frame(width: geo.size.width, height: geo.size.height * 0.40)
                    
                    Spacer()
                    
                    Text("Launch Date: \(self.mission.formattedLaunchDate)")
                        .padding()
                    
                    Text(self.mission.description)
                        .padding()
                    
                    Spacer()
                    
                    Section(header: Text("Mission Crew")) {
                        ForEach(self.astronauts, id: \.role) { crewMember in
                            NavigationLink(destination: AstronautView(astronaut: crewMember.astronaut)) {
                                HStack {
                                    Image(crewMember.astronaut.id)
                                        .resizable()
                                        .frame(width: 83, height: 60)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.primary, lineWidth: 1))
                                    
                                    VStack(alignment: .leading) {
                                        Text(crewMember.astronaut.name)
                                            .font(.headline)
                                        Text(crewMember.role)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    Spacer(minLength: 25)
                }
            }
        }
        .navigationBarTitle(Text(mission.displayName), displayMode: .inline)
    }
    
    init(mission: Mission, astronauts: [Astronaut]) {
        self.mission = mission
        
        var matches = [CrewMember]()
        
        for member in mission.crew {
            if let match = astronauts.first(where: { $0.id == member.name }) {
                matches.append(CrewMember(role: member.role, astronaut: match))
            } else {
                fatalError("Missing \(member)")
            }
        }
        
        self.astronauts = matches
    }
    
    func missionImageScaleEffect(_ geoRect: CGRect, _ fullRect: CGRect) -> CGFloat {
        let scale = geoRect.midY / fullRect.midY * 2
        
        return min(max(scale, 0.8), 1)
    }
}

struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        MissionView(mission: missions[0], astronauts: astronauts)
    }
}
