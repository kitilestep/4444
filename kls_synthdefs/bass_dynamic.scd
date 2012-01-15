(
// this synthdef has generative elements
SynthDef(\wobtest2_4444, { |freq=110, amp=0.1, wobrate=5, wobbuild=0.5, wobmin=100, wobmax=5000, wobstart=200, whichphase=2, gate=1, round=0.001, manster=0, out=0|
	var son, pur, cutoff, wobwob, sep;
	wobwob = [LFPar, LFPulse, LFSaw].wchoose([0.9, 0.05, 0.05]).kr(wobrate, whichphase);
	cutoff = wobwob.exprange(wobmin, XLine.kr(wobstart, wobmax, wobbuild));
	sep = exprand(0.001, 0.1);
	son = [Saw, Pulse, Blip].choose.ar(freq * [1 - sep, 1 + sep]).sum;
	son = LPF.ar(son, cutoff);
	son = Normalizer.ar(son);
	son = son + BPF.ar(son, exprand(1000, 2500), exprand(1, 4));
	/////// special flavours:
	son = Select.ar(manster, [son] ++ [ 
		// hi manster
		HPF.ar(son, 2500) * 4, 
		// sweep manster
		HPF.ar(son, cutoff * 0.75) * 4, 
		// ringmod clang
		son * LFTri.ar(Rand(1000)), 
		// harsh gate, fizzy sound
		son * (son.abs > 0.8),
		// round (alising hibits)
		son.round(exprand(0.03, 0.2)),
		// square gate locked to wobwob
		son * (wobwob>0),
		].scramble[1..]);
	son = son + GVerb.ar(son, 9, [0.7, 0.73], [0.73, 0.7], mul: 0.2);
	son = (son * exprand(1.5, 2.5)).clip2;
	
	pur = SinOsc.ar(Select.kr(freq > 100, [freq, freq * 0.125]) * [0.5]).sum * 0.5;
	son = son + pur;
	son = son * EnvGen.ar(Env.asr(0.01, 1, 0.01), gate);
	DetectSilence.ar(son, doneAction: 2);
	Out.ar(out, son * amp * 1.3)
}).add;
/*
x = Synth(\wobtest2_4444)
x.set(\amp, 0.4, \overtonestrength, 0.0, \nonwobmod, 1)
*/

// this synthdef has generative elements
SynthDef(\muzh_4444, { |freq=110, amp=0.1, wobrate=5, wobbuild=0.5, wobmin=100, wobmax=5000, wobstart=200, whichphase=2, gate=1, round=0.001, manster=0, out=0|
	var son, pur, cutoff, wobwob;
	var trig, env, env2, envhi, muzh, pikl, his;
	
	freq = [freq, freq.lagud(0.1)].choose;
	freq = [freq, freq * 0.5].choose;
	
	amp = Select.kr(freq > 200, [amp, amp * 0.7]);
	
	trig = Impulse.kr(wobrate * 0.5); //HPZ1.kr(freq).abs > 0;
	env = EnvGen.ar(Env.perc(0.15, 0.6), trig);

	// make enveloped bass note with high harmonics (saw)
	muzh = [
		Saw.ar(freq * [0.996, 1, 1.014]).product
		,
		Saw.ar(freq * SinOsc.ar(50).range(0.99, 1.01))
		].choose;
	muzh = (muzh * 100).clip2;
	muzh = (muzh * env).wrap(-1, 0.1);
	
	// pikl is fodder for the filt
	env2 = EnvGen.ar(Env.perc(0.085, 0.6), trig);
	pikl = BPF.ar(Saw.ar(freq * 8), freq * 32, 0.1) * env2.squared * rrand(0, 0.25);
	
	// push it through a v hi resonator whose resonant freq sweeps up or down
	envhi = ToggleFF.ar(trig).lag(0.3).linexp(0, 1, 2000, 11000);
	his = BPF.ar(muzh + pikl, envhi).clip2(0.01) * 10;
	
	// filter the bass note right down
	muzh = LPF.ar(muzh, min(freq * 16, 11000));
	
	// pur of course
	pur = SinOsc.ar(freq * 0.5);

	// mix and output
	son = (muzh + his + pur).dup;
	son = son * EnvGen.ar(Env.asr(0.01, 1, 0.01), gate);
	DetectSilence.ar(son, doneAction: 2);
	Out.ar(out, son * amp * 4.9)
}).add;
/*
x = Synth(\muzh_4444)
x.set(\amp, 0.4, \overtonestrength, 0.0, \nonwobmod, 1)
*/

"bass_d";
)
