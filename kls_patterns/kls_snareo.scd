(
~a4444[\define].value(\snareo, { |curebbs|
		// snare params change rarely
		(
			revtime:  rrand(0.5, 3.5),
			damping:  rrand(0.1, 0.9),
			spread:   rrand(0.1, 0.9),
			roomsize: rrand(9, 30),
			shortstop: exprand(0.02, 3.0)
		)
	}, { |curebbs, vars|
	Pbind(
		\instrument, \snare909dsds4444,
		\dur, 0.5,
		\amp, curebbs[\arousal].linlin(0.3, 0.7, 0.1, 0.15),
		\revtime,  vars[\revtime],
		\damping,  vars[\damping],
		\spread,   vars[\spread],
		\roomsize, vars[\roomsize],
		\shortstop,vars[\shortstop],
		\percussionon, ~a4444[\percussionon],
		\midinote, Pseq([\, \, if(curebbs[\density].linlin(0, 0.1, 0.9, 1).coin){60}{\ }, \, 
		                 \, \, if(curebbs[\density].linlin(0, 0.1, 0.9, 1).coin){60}{\ }, \ ])
	)
}, makebuild: nil /* TODO add some pattern? */ );
);

