// K L S WOOWOOWOO

// Start the server
s.latency_(0.4); s.options.memSize = 8192 * 4; s.boot;
// Load the scripts (you may need to CHANGE THIS PATH TO wherever yours are)
~mainfolder = (if(Document.current.notNil){Document.current.dir}{nil} ? "~/dev/4444kls").standardizePath.resolveRelative;
(~mainfolder +/+ "4444.scd").load;
(~mainfolder +/+ "kls_synthdefs/*.scd").loadPaths;
~init4444.value();

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 
(
TempoClock.default.tempo = 70/60;
~a4444[\filters].remove(\eko4444); // no use for dubstep. might be nice to add some more decent effects

// Load these pattern scriptfiles, AFTER the setup:
(~mainfolder +/+ "kls_patterns/*.scd").loadPaths;

"ok"
);

// Set up the recording style if you like
// s.recSampleFormat = "int16"; s.record("~/4d_latest%.aiff".format(3.rand).standardizePath);

s.recSampleFormat = "int24";
thisProcess.platform.recordingsDir_("~/".standardizePath);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// GO: (record a track)
~start4444.value(0.01, initebbs:(arousal: 0.3, valence: 0.5, density: 0.4), record: 2, amp: 0.9, trackdur: 16);
// GO: (play continuously, without recording)
~start4444.value(0.01, initebbs:(arousal: 0.8, valence: 0.5, density: 0.4), record: 0, amp: 0.9, trackdur: nil);



// Some examples of tweaks that can be done live
~a4444[\outmixproxy].set(\pregain, 5)  // how much gain before the final compression/distortion of the mix

~a4444[\setebb].value(\arousal, 0.9)

~a4444[\outmixgroup].set(\amp, 0.9)




//////////////////////////////////////////////////////////////////////////////////////////////////////
// just a homemade thing for the mic
(
~micthing ?? {
	~micthing = NodeProxy.audio(s, 2);
	~micthing.group = ~a4444[\ebbgroup];
};
{
	~micthing.source = {
		var son = SoundIn.ar(0);
		var control = MouseY.kr(0,1);
		//Out.kr(~a4444[\percussionon], (MouseX.kr < 0.85));
		son = BRF.ar(BRF.ar(son, 9000, 0.5), 2000, 0.5); // pinkening
		son = son.freeverb(0.2, 0.5, 0.99);
		//son = AutoStutter1.ar(son, control * (control>0.9));
		son = son * 0.85; //* (control > 0.5);
		son.dup
	};
	~micthing.play
}.defer(0.1);
)
//~micthing.source = nil

~a4444[\outmixgroup].set(\amp, 0.5)

x = {Amplitude.ar(In.ar(0), 0, 2).poll; DC.ar(0)}.play(s, addAction: \addToTail);
x.free;

~stop4444.value;    // restartable after this.
~dispose4444.value; // final disposal, going home.
