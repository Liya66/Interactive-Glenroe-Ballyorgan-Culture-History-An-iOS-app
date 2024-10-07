//
//  ContentItem.swift
//  Glenroe-Ballyorgan
//
//  Created by Liya Wang on 2024/8/3.
//

import Foundation


struct ContentItem {
    var id: String
    let title: String
    let description: String
    let imageURL: String
    let category: String
}

class StoryManager {
    static let shared = StoryManager()
    
    private init() {} // Private initializer to enforce singleton pattern
    
    func fetchStories() -> [ContentItem] {
        return [
            ContentItem(
                id:"1",
                title: "Glenroe-Ballyorgan History",
                description: """
The old name of the parish was Darragh. The parish used to include the parish of Kilflyn, which is known today as Ballyorgan. According to Begley, the old parish of Darragh included Farrihy, Kildorrery and Mullahy. All three of these places are in the county of Cork and in the present diocese of Cloyne.

The Red Chair crossroads marks the border with County Cork. This crossroads is the site of the murder of Mahon, King of Munster in 976. Mahon had been on a visit to Bruree when he was captured and killed by his rivals. He was succeeded by his younger brother Brian Boru, who later went on to become the High King of Ireland and died at the Battle of Clontarf in 1014.

The area is also connected with many of the legends of the Fianna. The Ballahoura Mountains were the hunting grounds where the Fianna used to hunt the Liath na dTrí mBeann "the grey one of the three antlers". According to legend St Patrick visited the area about 460 and that he was shown around the region by one of the warriors of the Fianna, Caoilte.

The Ballahoura Mountains include Kilcruaig Mountain, which stands at 1,323 feet, and the Galtee Mountains, which dominate the surrounding countryside. The Palatines came to this area to settle and helped in the development of the area during the 18th century. The population of the parish is currently around 750.

""",
                imageURL: "History_image.png",
               
                category: "History"
            ),
            ContentItem(
                id:"2",
                title: "Glenroe Church",
                description: """
                The present church in Glenroe was built in 1830-2 during Fr Darby Buckley's term as parish priest. Before this church was built, people used to go to mass in Abbey and prior to that again mass was held in Darragh. However, the church used was not the church ruin that exists in Darragh today, but was in fact another church situated nearby. The present church in Glenroe was renovated about 10 years ago and was reopened in 1990 by Bishop Jeremiah Newman and Fr Michael Lane P.P.
                """,
                imageURL:"Glenroechurch.jpg",
                category: "Churches"
            ),
            ContentItem(
                id:"3",
                title: "Ballyorgan Church",
                description: "Discover the legend that has been passed down through generations.",
                imageURL:"Ballyorganchurch.jpg",
                //https://freepages.rootsweb.com/~irishchurches/genealogy/RC%20Churches/Ballyorganchurch.jpg
                category: "Churches"
            ),
            ContentItem(
                id:"4",
                title: "Church Ruins",
                description: """
                The church ruin in Darragh consists of a nave and choir and is situated in the far corner of Darragh graveyard. An inscription over the ruin reads "Frederick Bevan 1839"and the wall at the entrance to the grounds also bears an inscription, which says that the wall was built in 1829 by Bevan. The Bevans were the local landlords and their seat was at Darragh House.

                Fr Lane told us that this might have been the site of a convent. It is believed that an order of nuns stayed here before moving to Youghal, Co. Cork. In the farthest corner of the grounds, it seems that there may have been other buildings on this site previously. A wall that runs along parallel from the church ruin makes this evident.

                The grounds are well maintained. There is a graveyard on the site as well.

                Westropp mentions a church in Kilflyn. A Church of Ireland now stands on the site. He also lists Manister na nGall or Keale, which was in the old parish of Kilflin, founded by Roche in the fourteenth century for the Dominicans.
                """,
                imageURL: "darragh.jpg",//https://s3.eu-west-1.amazonaws.com/irelandxo.com/s3fs-public/styles/full_width_image/public/d7_files/default_images/darragh.jpg?itok=DHVRtjoZ
                category: "Churches"
            ),
            ContentItem(
                id:"5",
                title: "Darragh Graveyard",
                description: """
                At Darragh, the oldest headstone that we found was in memory of John Moynihan who died on March 27th, 1778. However, according to the book "God's Acre", which gives details on all the graveyards in the parish, the oldest headstone in the graveyard is in memory to Patrick Clifford who died on May 3rd 1741, aged 38.
                """,
                imageURL: "Darragh Graveyard.jpg",
                category: "Graveyards"
            ),
            ContentItem(
                id:"6",
                title: "Abbey Graveyard",
                description: """
                Abbey graveyard is located in the townland of Abbey. It is well maintained, and new paths have recently been laid throughout the graveyard. The ruins of a church are situated within the grounds of the graveyard. According to "God's Acre" the oldest headstone in the graveyard at Abbey dates from 1772. This headstone is in the memory of Hanora Corbett who died February 9th, 1772, aged 72.
                """,
                imageURL: "Abbey Graveyard.jpeg",//https://historicgraves.com/sites/default/files/gyard-photo/co-abby/dsc02054.jpg
                category: "Graveyards"
            ),
            ContentItem(
                id:"7",
                title: "Glenroe Graveyard",
                description: """
                 The oldest headstone in the graveyard beside the church at Glenroe is in memory to Fr James Walsh C.C. of Newcastlewest. Fr Walsh died on February 6th 1851 at the age of 28. This graveyard was extended in 1960.
                 """,
                imageURL: "graveyardGlenroe.jpg",
                category: "Graveyards"
            ),
            ContentItem(
                id:"8",
                title: "Holy Wells",
                description: """
                Danaher's "Holy Wells of County Limerick" mentions three Holy Wells in the parish. Only one well remains, however, Toberbreedia at Ballintobber. The only trace of this well is a hole in the ground. The well was usually visited on February 1st but rounds were rarely made. The well is locally called Chincough Well and was said to cure whooping cough in children. Patients seeking cures could drink water taken from the well, or could go to the well and drink there. Moss was sometimes taken from the well and boiled in milk. The patient would drink the milk in order to be cured.

                There are two legends surrounding the well. It is said that a fowler washed his dog in the well and caused it to move. One of the most interesting legends about any of the wells in the diocese occurs at Ballintobber. A phantom bull is supposed to guard a treasure buried at the well. What this treasure is or whether anyone has ever looked for it, we do not know.

                The locations of the other two wells in the parish are now unknown. In the old parish of Kilflyn, there was a well in the townland of Ballydonohoe called Toberpatrick. This well was in a small grove of trees but devotions have long since ceased at this site.

                In the townland of Darraghmore there was a well called Tobar Mo-chua. This well was enclosed in rough stone work in a grove of beech trees on the hillside. A pattern was held at the well on August 31st, St. Mochua's feastday, until around 1820. Westropp, however, claims that the feastday is on August 3rd.

                The water from this well was said to cure many illnesses. According to legend, when clothes were washed in the well, it moved 400 yards from its original location near the churchyard in Darragh to its present location. Those who were to be cured were said to see a trout in the well. A man once caught the trout thinking it was an ordinary fish and then attempted to cook it but failed in his efforts. He returned the trout to the well.
                """,
                imageURL:"Holy Well.jpg",//https://heritage.clareheritage.org/wp-content/uploads/sites/6/2021/09/Finnor-More-374x249.jpg
                category: "Local Sites"
            ),
            ContentItem(
                id:"9",
                title: "Abbey",
                description: """
                  The Abbey is situated in the townland of the same name. It is believed that a monastery was founded here in the 7th or 8th century. By the 14th century the Dominican order had established a house here. It was suppressed during the Reformation. The last prior was Donough O'Dorgan in 1558. Over the years the Abbey became a centre of devotion and people used to travel from miles around to come to mass at the Abbey.
                  
                  The ruin of the abbey still stands but there were probably more buildings at the time when the abbey was abandoned. Paths have now been laid throughout the graveyard. A pathway has also been laid from the road, which enables people to walk into the ruin.
                  """,
                imageURL: "Abbey.jpg",//https://historicgraves.com/sites/default/files/gyard-photo/li-abgb/dsc05308.jpg
                category: "Local Sites"
            ),
            ContentItem(
                id:"10",
                title:"Darragh Bridge",
                description: """
Single-arch sandstone bridge over the River Ahaphuca, built c. 1820, having coursed dressed walls with ashlar stringcourse and copings. Rusticated voussoirs to segmental-headed arches. Recent plaque to west parapet wall.
The dressed sandstone walls and rusticated voussoirs of this bridge attest to high quality craftsmanship, whilst its solid form is of technical and civil engineering interest. The bridge forms a striking silhouette in the landscape and forms an integral part of the architectural heritage of the locality.
""",//from https://www.buildingsofireland.ie/buildings-search/building/21905703/darragh-bridge-middleborough-darragh-limerick
            imageURL: "Darragh Bridge.png",
            category: "Local Sites"),
            ContentItem(
                id:"11",
                title: "About",
                description: """
                This app offers interactive audio and VR experience, aiming to preserve and present the local cultures and histories of Glenroe-Ballyorrgan.
                
                Have you guessed that what the icon reprents? The bird and river is for the AR Keale River Tour! And the tree represent tranquil scenery of the Glenroe-Ballyorgan area.
                
                The preliminary functionalities of the app are considered fully implemented, and future versions will improve the AR experience with more information, more models and more interactions, e.g., hand gestures.For audio tour, there might be a need to present live script as well. Also, there will be more user actions in the future!
                
                THe content in the app still needs to be enriched, as there might be more stories, oral or written, that are of interest for people who love histories and cultures. Then, more interactive tours can be designed to deliver those new stories.
                
                Overall accessbility will be furthur enhanced.
                
                Thanks for everyone who was envolved to help build this project, especially the Rural Recreation Officer Mike Clreay from Ballyhoura Development CLG for proposing this idea and connecting with local community.
                
                Welcome to propose your idea to help build this app better! Send an email to 123100114@umail.ucc.ie :)
                
                --Liya, September 2024
                """,
                imageURL: "myIcon.png",
                category: "More Info"
            ),
        ]
    }
}
