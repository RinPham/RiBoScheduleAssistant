//
//  SpeechViewController.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 4/10/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit
import Speech

protocol SpeechViewControllerDelegate: class {
    func getResultText(text: String)
}

class SpeechViewController: UIViewController {
    
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var voiceImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    weak var delegate: SpeechViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.showAnimate()
        self.setup()
        self.setupSpeechRecognizer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func shared() -> SpeechViewController? {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: AppID.IDSpeechViewController) as? SpeechViewController
        return vc
    }
    
    fileprivate func setup() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(close))
        self.view.addGestureRecognizer(tapGesture)
        
        self.boxView.cornerRadius(10, borderWidth: 0, color: .clear)
        self.closeButton.setImage(#imageLiteral(resourceName: "ic_cancel").withRenderingMode(.alwaysTemplate), for: .normal)
        self.closeButton.tintColor = UIColor.white
        
    }
    
    fileprivate func setupSpeechRecognizer() {
        speechRecognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            var isButtonEnabled = false
            
            switch authStatus {  //5
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            if isButtonEnabled {
                self.startRecording()
            }
        }
    }
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                self.contentTextView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            //inputNode.removeTap(onBus: 0)
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                //self.microphoneButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        //textView.text = "Say something, I'm listening!"
    }
    
    @IBAction func didTouchUpInsideDoneButton(_ sender: UIButton) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
        }
        if self.contentTextView.text != "" {
            self.delegate?.getResultText(text: self.contentTextView.text)
        }
        self.close()
    }
    
    @IBAction func didTouchUpInsideCloseButton(_ sender: UIButton) {
        self.close()
    }
    
    @IBAction func didTouchUpInsideRetryButton(_ sender: UIButton) {
        sender.isEnabled = false
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            sender.isEnabled = true
            self.contentTextView.text = ""
            if !self.audioEngine.isRunning {
                self.startRecording()
            }
        }
    }

    @objc func close() {
        self.removeAnimate()
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            self.view.alpha = 0.0
        }, completion: {(finished : Bool) in
            if(finished)
            {
                self.willMove(toParentViewController: nil)
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
            }
        })
    }
}

extension SpeechViewController: SFSpeechRecognizerDelegate {
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        
    }
    
}
