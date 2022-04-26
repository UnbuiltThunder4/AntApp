//
//  File.swift
//  
//
//  Created by Eugenio Raja on 18/04/22.
//

/**
 Do: 72
 Do#/Reb: 73
 Re: 74
 Re#: 75
 Mi: 76
 Fa: 77
 Fa#/Solb: 78
 Sol: 79
 Lab: 80
 La: 81
 Sib: 82
 Si: 83
 
 Do: 84
 
 Accordi "positivi":
 Do - Mi - Sol
 Fa - La - Do
 Sib - Re - Fa
 
 Accordi "negativi":
 Re - Fa - La
 La - Do - Mi
 */

import Foundation
import AudioToolbox

class MusicPlayerManager {
    let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
    
    static let sharedInstance = MusicPlayerManager()
    public init() {}
    
    var musicPlayer : MusicPlayer? = nil
    var sequence : MusicSequence? = nil
    var track : MusicTrack? = nil
    var time = MusicTimeStamp(1.0)
    var player: OSStatus? = nil
    var musicTrack: OSStatus? = nil
    
    func playNotes(note: UInt8) {
        DispatchQueue.main.async {
            _ = NewMusicSequence(&self.sequence)
            self.player = NewMusicPlayer(&self.musicPlayer)
            self.player = MusicPlayerSetSequence(self.musicPlayer!, self.sequence)
            self.player = MusicPlayerStart(self.musicPlayer!)
            self.musicTrack = MusicSequenceNewTrack(self.sequence!, &self.track)
            var truenote = MIDINoteMessage(channel: 0,
                                           note: note,
                                           velocity: 64,
                                           releaseVelocity: 0,
                                           duration: 1.0)
            guard let track = self.track else {fatalError()}
            self.musicTrack = MusicTrackNewMIDINoteEvent(track, self.time, &truenote)
            self.player = MusicPlayerSetSequence(self.musicPlayer!, self.sequence)
            self.player = MusicPlayerStart(self.musicPlayer!)
        }
    }
}
