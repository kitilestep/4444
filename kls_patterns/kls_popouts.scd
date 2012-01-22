(
~a4444[\define].value(\popout, {
		~a4444[\d][\popout][\group].moveToTail(~a4444[\outmixgroup]); // ensure can silence all
		(
			modfrom: exprand(1000, 10000),
			modto: exprand(1000, 10000),
			defnames: [\popout4444ds1stick, \popout4444ds1stickglitch, \popout4444ds1wee, \popout4444ds1hpf, \popout4444ds1slur].scramble,
			defweights: ~a4444[\stickbreak1plus].value(5, rrand(0.8, 1.0))
		)
	}, { |curebbs, vars|
	Pwrand([
		Pbind(
			\instrument, Pwrand(vars[\defnames], vars[\defweights], inf).trace,
			// three poss popout patterns:
			[\dur, \midinote], Prand([
				Pseq([[1  , 60],            [3, \r ]]),
				Pseq([[0.5, \r ], [0.5, 60], [3, \r ]]),
				Pseq([[0.5, 60], [3.5, \r ]])
				]).trace,
			\amp, 0.05,
			\modfrom, vars[\modfrom],
			\modto, vars[\modto],
			\frac, Prand(1/[2, 3, 4], inf),
			\legato, 1
		),
		Pbind(
			\midinote, \,
			\dur, Pseq([4])
		)], 
	[0.2, 0.8], 3)
}, 4, makebuild: nil);
~a4444[\d][\popout][\onprob] = { |curebbs| if(curebbs[\density] > 0.65){1}{0.01} * curebbs[\arousal].linlin(0.5,0.85, 0, 0.99) };
/*
~a4444[\d][\popout][\onprob] = 1;
*/
~a4444[\d][\popout][\maypull] = false;
);

