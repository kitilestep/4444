(
SynthDef(\kick4444dsjl, { |out=0, amp=1, freqa=40, freqb=200, len=0.01, percussionon=0|
	var son, bassenv;
	bassenv = Decay.ar(Impulse.ar(0),exprand(0.4, 1.5));
	son = SinOsc.ar(freqa+(bassenv**3 * freqb), Rand(0, 2pi), rrand(4,10)*bassenv).clip2;
	DetectSilence.ar(son, doneAction: 2);
	son = son * (In.kr(percussionon)>0); // percussionon
	amp = AmpComp.ir(freqa + freqb) * amp;
	Out.ar(out, son.dup * amp);
}).add;
);

(
SynthDef(\snarei44441, { |out=0, amp=1, centrefreq=4500, percussionon=0, pan=0|
	var son;
	amp = AmpComp.ir(centrefreq) * amp;
	son = (BPF.ar(WhiteNoise.ar(2), centrefreq) * Line.ar(1,0, 0.085, doneAction: 2)).tanh;
	son = son * (In.kr(percussionon)>0); // percussionon
	son = LPF.ar(son, XLine.ar(800, 20000, 0.005));
	Out.ar(out, Pan2.ar(son, pan) * amp);
}).add;
);

(
SynthDef(\snare909dsds4444,{ |out=0,amp=1, roomsize=9, revtime=0.7, damping=0.7, spread=0.5, percussionon=0, shortstop=0.4|
	var excitation, membrane, son; 
	excitation = LPF.ar(WhiteNoise.ar(1), exprand(6500, 10000), 1)  * (In.kr(percussionon)>0);
	membrane = (
	  /* Two simple enveloped oscillators represent the loudest resonances of the drum membranes */ 
	    (LFTri.ar(exprand(250, 750),0,1) * EnvGen.ar(Env.perc(0.0005,0.055),doneAction:0) * 0.25) 
	   +(LFTri.ar(exprand(150, 250),0,1) * EnvGen.ar(Env.perc(0.0005,0.075),doneAction:0) * 0.25)
	  /* Filtered white noise represents the snare */ 
	   +(excitation * EnvGen.ar(Env.perc(exprand(0.0004,0.0007),exprand(0.3,0.5)),doneAction:0) * 0.2) 
	   +(HPF.ar(excitation, exprand(450, 600), 1) * EnvGen.ar(Env.perc(0.0005,0.283),doneAction:0) * 0.2)
	  ) * amp;
	son = ((membrane * 0.5) + PitchShift.ar(membrane, 0.05, exprand(0.35, 0.8), 0, 0) * 4).distort;
	son = son * EnvGen.ar(Env([1,1,0], [1,0]), timeScale: shortstop);
	son = LeakDC.ar(GVerb.ar(son, roomsize: roomsize, revtime: revtime, damping: damping, drylevel: [0.75, 0.76], spread: spread, maxroomsize: roomsize));
	// pull the amplitude down if big reverb, since it tends to boost loudness
	son = son * revtime.linlin(0.5, 3.5, 1.2, 0.7);
	DetectSilence.ar(son, doneAction: 2);
	//son = son * (In.kr(percussionon)>0); // percussionon
	Out.ar(out, son)
}).add;
);

"drums";

