const jsPsych = initJsPsych({
    on_finish: function () {
        jsPsych.data.displayData('csv');
      }
  });

let timeline = [];

// push experiment logic to timeline here
// 1 consent form
// 2 instructions
// 3 experiment body (loop through stimuli ) -- trial 1 (audio + keyboard response), trial 2 ...
// 4 questionnaire

const irb = {
    type: jsPsychHtmlButtonResponse,
    stimulus: '<p><font size="3">We invite you to participate in a research study on language production and comprehension. Your experimenter will ask you to do a linguistic task such as reading sentences or words, naming pictures or describing scenes, making up sentences of your own, or participating in a simple language game. <br><br>There are no risks or benefits of any kind involved in this study. <br><br>You will be paid for your participation at the posted rate.<br><br>If you have read this form and have decided to participate in this experiment, please understand your participation is voluntary and you have the right to withdraw your consent or discontinue participation at anytime without penalty or loss of benefits to which you are otherwise entitled. You have the right to refuse to do particular tasks. Your individual privacy will be maintained in all published and written data resulting from the study. You may print this form for your records.<br><br>CONTACT INFORMATION: If you have any questions, concerns or complaints about this research study, its procedures, risks and benefits, you should contact the Protocol Director Meghan Sumner at (650)-725-9336. If you are not satisfied with how this study is being conducted, or if you have any concerns, complaints, or general questions about the research or your rights as a participant, please contact the Stanford Institutional Review Board (IRB) to speak to someone independent of the research team at (650)-723-2480 or toll free at 1-866-680-2906. You can also write to the Stanford IRB, Stanford University, 3000 El Camino Real, Five Palo Alto Square, 4th Floor, Palo Alto, CA 94306 USA.<br><br>If you agree to participate, please proceed to the study tasks.</font></p>',
    choices: ['Continue']
};
timeline.push(irb);

const instructions = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: "In this experiment, you will hear a series of words. If it's your first time hearing the word, press 'D' for NEW. If you've already heard the word during the task, press 'K' for OLD. Try to respond as quickly and accurately as you can.<br>When you're ready to begin, press the space bar.",
    choices: [" "]
};
timeline.push(instructions);

const trials = {
    type: jsPsychAudioKeyboardResponse,
    choices: ['d', 'k'],
    stimulus: 'audio/Violin.wav',
    response_allowed_while_playing: false,
    trial_duration: 4000,
    prompt: `<div class=\"option_container\">
    			<div class=\"option\">NEW<br><br><b>D</b></div>
    			<div class=\"option\">OLD<br><br><b>K</b></div>
    		</div>`,
    data: {
        correct: "NEW"
    },
    on_finish: function(data) {
    	evaluate_response(data);
    },
    timeline: [
        {stimulus: 'audio/Violin.wav', data: {correct: "NEW"}},
        {stimulus: 'audio/Bologna.wav', data: {correct: "NEW"}},
        {stimulus: 'audio/Violin.wav', data: {correct: "OLD"}},
        {stimulus: 'audio/Bologna.wav', data: {correct: "OLD"}}
    ]
};
timeline.push(trials);

jsPsych.run(timeline);