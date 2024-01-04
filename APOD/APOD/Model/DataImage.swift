//
//  APODModel.swift
//  APOD
//
//  Created by Irina on 27.10.2023.
//

import Foundation

struct DataImage: Decodable {
    var copyright, date, explanation: String?
    var hdurl: String?
    var mediaType, serviceVersion, title: String?
    var url: URL?

    enum CodingKeys: String, CodingKey {
        case copyright, date, explanation, hdurl
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title, url
    }
}

//{
//    "copyright":"Dan Bartlett",
//    "date":"2023-10-27",
//    "explanation":"History's second known periodic comet is Comet Encke (2P/Encke). As it swings through the inner Solar System, Encke's orbit takes it from an aphelion, its greatest distance from the Sun, inside the orbit of Jupiter to a perihelion just inside the orbit of Mercury. Returning to its perihelion every 3.3 years, Encke has the shortest period of the Solar System's major comets. Comet Encke is also associated with (at least) two annual meteor showers on planet Earth, the North and South Taurids. Both showers are active in late October and early November. Their two separate radiants lie near bright star Aldebaran in the head-strong constellation Taurus. A faint comet, Encke was captured in this telescopic field of view imaged on the morning of August 24. Then, Encke's pretty greenish coma was close on the sky to the young, embedded star cluster and light-years long, tadpole-shaped star-forming clouds in emission nebula IC 410. Now near bright star Spica in Virgo Comet Encke passed its 2023 perihelion only five days ago, on October 22.",
//    "hdurl":"https://apod.nasa.gov/apod/image/2310/2P_Encke_2023_08_24JuneLake_California_USA_DEBartlett.jpg",
//    "media_type":"image",
//    "service_version":"v1",
//    "title":"Encke and the Tadpoles",
//    "url":"https://apod.nasa.gov/apod/image/2310/2P_Encke_2023_08_24JuneLake_California_USA_DEBartlett1024.jpg"}
