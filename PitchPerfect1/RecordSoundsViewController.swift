//
//  RecordSoundsViewController.swift
//  PitchPerfect1
//
//  Created by Amr on 2912//18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController ,AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(isRecording: true)
        
    }
    
    func configureUI(isRecording: Bool) {
        stopRecordingButton.isEnabled = !isRecording
        recordButton.isEnabled = isRecording
        if(isRecording){
            recordingLabel.text = "Tap to Record"
            

        }else{
            recordingLabel.text = "Recording in progress .."

        }
    }
   
 
 
    @IBAction func recordAudio(_ sender: Any) {
        print("Pressed")
      
        configureUI(isRecording: false)
      
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(isRecording: true)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
       if flag {
           performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)

        }else {
            showAlert()
        
        }
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Alert", message: "Recording wasn't successful", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            
            let playSoundsVC = segue.destination as!PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
            
        }
    }
    
}

