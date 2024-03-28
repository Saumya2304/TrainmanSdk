//
//  SavePDFFile.swift
//  TrainmanBooking_iOSSDK
//
//  Created by Somya on 13/05/22.
//

import Foundation
protocol SavePdfdelegate:AnyObject{
   func successPdfSave(url:URL)
   func failurePdf()
}

class SavePDFFile{
    
    var delegate: SavePdfdelegate?
    
    func savePdf(urlString:String, fileName:String) {
            DispatchQueue.main.async {
                let url = URL(string: urlString)
                let pdfData = try? Data.init(contentsOf: url!)
                let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
                let pdfNameFromUrl = "\(fileName).pdf"
                let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
                do {
                    try pdfData?.write(to: actualPath, options: .atomic)
                    print("pdf successfully saved!")
                    self.showSavedPdf(url: urlString, fileName: urlString)
                } catch {
                    self.delegate?.failurePdf()
                    print("Pdf could not be saved")
                }
            }
        }
    
    func showSavedPdf(url:String, fileName:String) {
            if #available(iOS 10.0, *) {
                do {
                    let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                    for url1 in contents {
                        if url1.description.contains(".pdf") {
                          guard let url = URL(string: url) else { return }
                           self.delegate?.successPdfSave(url: url)
                    }
                }
            } catch {
                self.delegate?.failurePdf()
                print("could not locate pdf file !!!!!!!")
            }
        }
    }

}
