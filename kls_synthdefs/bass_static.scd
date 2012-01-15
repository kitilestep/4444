// Static bass synthdefs.
(
SynthDef(\bassnonwob44441, { |out=0, amp=1, freq=110, gate=1, overtonestrength=1, wobrate=1, nonwobmod=0|
	var son;
	son = (SinOsc.ar(freq * [0.5, 1] * LFNoise0.kr(2).range(0.99, 1.01), mul: 4) * [1.0, 0.9 * overtonestrength]).sum.tanh;
	son = LPF.ar(son, LFCub.kr(wobrate * 0.25).range(1-nonwobmod, 1).linexp(0, 1, 30, 500));
	son = son * amp * EnvGen.ar(Env.asr(0.01, 1, 0.01), gate);
	DetectSilence.ar(son, doneAction: 2);
	Out.ar(out, son.dup);
}).add;
);
/*
x = Synth(\bassnonwob44441)
x.set(\amp, 0.4, \overtonestrength, 0.0, \nonwobmod, 1)
*/
(
/*
~a4444.d.wob.vars.wobber = \werwub44441  // to force it!
*/
SynthDef(\werwub44441, { |freq=110, out=0, filteropen=1, t_trig=0, long=1, amp=0.1, gate=1, overtonestrength=1, manster=0, wobmin=40|
	var son, env, multifreq;
	multifreq = [freq, freq * 0.25, freq * 4, freq * 32];
	multifreq = multifreq.collect{|f| Select.kr(f>10000, [f, f*0.125])};
	son = (Saw.ar(multifreq * Saw.ar(min(15000, freq*exprand(2.0, 3.0))).exprange(0.99, 1.01)) * [1, 1, 0.3*overtonestrength, 0.2*overtonestrength]).sum;
// freq.poll;	//son.poll;
	env = EnvGen.ar(Env([1, 1, 10000, 10000], [0.01, 0.1, 1], 'exp'), 1 - t_trig)
		* (EnvGen.ar(Env([0, 0, -1, -1], [0.1, 0.1, 1], 'lin'), 1 - t_trig) * (1-long) + 1).lag(0.1)
		;
	env = LPF.ar(env, 20);
	son = LPF.ar(son, env.max(0) + (wobmin * 0.5));
	son = son + BPF.ar(son, exprand(1500, 3500), 0.5);
	son = Normalizer.ar(son);
	son = (son * 2).tanh;
	//manster.poll(HPZ1.kr(manster).abs>0, "manster");
	/////// special flavours:
	son = Select.ar(manster, [son, 
		// hi manster
		HPF.ar(son, 2500) * 4, 
		// yorrrrr yaaaaa or whatever
		(BPF.ar(BPF.ar(son, EnvGen.kr(Env([ 300,  300, 450, 450], [0, 0.2, 0], 'exp'), t_trig), 0.4),
		                    EnvGen.kr(Env([2300, 2300, 740, 740], [0, 0.2, 0], 'exp'), t_trig), 0.4) * 44).tanh,
		// ringmod clang
		son * LFTri.ar(Rand(1000)), 
		// harsh gate, fizzy sound
		son * (son.abs > 0.8),
		// round (alising hibits)
		son.round(0.1),
		// square gate locked to, um...
		son * (env>1000),
		].scramble[1..]);
	// add pur sub
	son = son + SinOsc.ar(freq * 0.25 * (EnvGen.ar(Env.perc(0.2), t_trig)+1));
	//freq.poll;
	//son.poll;
	Out.ar(out, (son * amp * EnvGen.ar(Env.asr(0, 1, 0.02), gate, doneAction: 2) * 1.8).dup);
}).add;
);

"bass_s";

