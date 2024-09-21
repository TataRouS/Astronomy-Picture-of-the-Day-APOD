//
//  PictureOfTheDayWidget.swift
//  PictureOfTheDayWidget
//
//  Created by Alexander Rubtsov on 10.12.2023.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> ImageEntry {
        ImageEntry(date: Date(), image: UIImage())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> ImageEntry {
        ImageEntry(date: Date(), image: UIImage())
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<ImageEntry> {
        var entries: [ImageEntry] = []
        let currectDate = Calendar.autoupdatingCurrent.startOfDay(for: Date())
        let nextUpdate = Calendar.autoupdatingCurrent.date(byAdding: .day,
                                                           value: 1,
                                                           to: currectDate)!
        let apodModel = try? await NetworkService().requestData()
        let image = try? await extractUIImage(apodModel?.hdurl)
        
        let entry = ImageEntry(date: nextUpdate, image: image)
        entries.append(entry)
        return Timeline(entries: entries, policy: .after(nextUpdate))
    }
    
    private func extractUIImage(_ hdurl: String?) async throws -> UIImage {
        enum PictureFetcherError: Error {
                case imageDataCorrupted
            }
        
        guard let strongHDUrl = hdurl,
              let url = URL (string: strongHDUrl) else {
            throw PictureFetcherError.imageDataCorrupted
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let uiimage = UIImage(data: data) else {
            throw PictureFetcherError.imageDataCorrupted
        }
        
        return uiimage
    }
}

struct ImageEntry: TimelineEntry {
    var date: Date
    let image: UIImage?
}

struct PictureOfTheDayWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        if let image = entry.image {
            Image(uiImage: image)
                .resizable()
                .frame(width: 400, height: 400)
                .clipped()
        } else {
            Color.red
        }
    }
}

struct PictureOfTheDayWidget: Widget {
    let kind: String = "PictureOfTheDayWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            PictureOfTheDayWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

#Preview(as: .systemSmall) {
    PictureOfTheDayWidget()
} timeline: {
    ImageEntry(date: .now, image: UIImage(systemName: "cross") ?? UIImage())
}
