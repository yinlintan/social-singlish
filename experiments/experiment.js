const jsPsych = initJsPsych({
    show_progress_bar: true,
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

const preload_array = ['audio/Violin.wav', 'audio/F1_01.wav', 'audio/F1_02.wav'];
const preload_trial = {
    type: jsPsychPreload,
    audio: preload_array
};

const irb = {
    type: jsPsychHtmlButtonResponse,
    stimulus: '<p><font size="3">We invite you to participate in a research study on language production and comprehension. Your experimenter will ask you to do a linguistic task such as reading sentences or words, naming pictures or describing scenes, making up sentences of your own, or participating in a simple language game. <br><br>There are no risks or benefits of any kind involved in this study. <br><br>You will be paid for your participation at the posted rate.<br><br>If you have read this form and have decided to participate in this experiment, please understand your participation is voluntary and you have the right to withdraw your consent or discontinue participation at anytime without penalty or loss of benefits to which you are otherwise entitled. You have the right to refuse to do particular tasks. Your individual privacy will be maintained in all published and written data resulting from the study. You may print this form for your records.<br><br>CONTACT INFORMATION: If you have any questions, concerns or complaints about this research study, its procedures, risks and benefits, you should contact the Protocol Director Meghan Sumner at (650)-725-9336. If you are not satisfied with how this study is being conducted, or if you have any concerns, complaints, or general questions about the research or your rights as a participant, please contact the Stanford Institutional Review Board (IRB) to speak to someone independent of the research team at (650)-723-2480 or toll free at 1-866-680-2906. You can also write to the Stanford IRB, Stanford University, 3000 El Camino Real, Five Palo Alto Square, 4th Floor, Palo Alto, CA 94306 USA.<br><br>If you agree to participate, please proceed to the study tasks.</font></p>',
    choices: ['Continue']
};
timeline.push(irb);

/* eligibility */
const intro1 = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus:  `<p>Only complete this study if you are a Singaporean citizen or Singapore Permanent Resident (PR) who is 18 years old or older.</p>
            <p>Please share this link with other Singaporean citizens and Singapore PRs, but do not participate in this study more than once. You will not be compensated more than once.</p>
            <p>Press the SPACE BAR to continue.</p>`,
    choices: [" "],
};
timeline.push(intro1);

/* instructions */
const intro2 = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus:  `This experiment should be completed on a desktop or laptop using the Google Chrome browser.
    <BR><BR>Please ensure that you are wearing earphones or headphones for the duration of this experiment.
    <BR><BR>Press the SPACE BAR to continue.`,
    choices: [" "],
};
timeline.push(intro2);

/* sound check 
Put one of the deleted processed audio clips and have them type in the last word in the clip.
*/
const soundcheck = {
  type: jsPsychCloze,
  text: `<center><BR><BR><audio controls src="audio/soundcheck.wav"></audio></center><BR><BR>Listen carefully to the audio clip above. Type the LAST WORD that was said into the blank below and press "Continue".<BR><BR>% friends %`,
  check_answers: true,
  button_text: 'Continue',
  mistake_fn: function () { alert("Wrong answer. Please make sure your audio is working properly and try again.") }
};
timeline.push(soundcheck);

const instructions = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus:  `In this experiment, you will listen to short audio clips.
    <BR><BR>After listening to each clip, please evaluate the speaker by indicating how much you agree or disagree with the provided statements.
    <BR><BR>Please listen to the audio clip BEFORE answering the questions.
    <BR><BR>Press the SPACE BAR to continue.`,
    choices: [" "]
};
timeline.push(instructions);

var likert_scale = [
  "Strongly Disagree", 
  "Disagree", 
  "Somewhat Disagree",
  "Neutral", 
  "Somewhat Agree",
  "Agree", 
  "Strongly Agree"
];

const trials = {
    type: jsPsychSurveyLikert,
    preamble: `<p>Please listen to the following audio clip.</p>
                <p><center><audio controls src="audio/F1_01.wav"></audio></center></p>
                <p>Rate how much you agree or disagree with the following statements:</p>`,
    data: {
        stimulus: "F1_01"
    },
    questions: [
        {prompt: "The speaker is ARTICULATE.", name: 'articulate', labels: likert_scale, required: true},
        {prompt: "The speaker is HONEST.", name: 'honest', labels: likert_scale, required: true},
        {prompt: "The speaker is ROUGH.", name: 'rough', labels: likert_scale, required: true},
        {prompt: "The speaker is AUTHENTIC.", name: 'authentic', labels: likert_scale, required: true},
        {prompt: "The speaker is COMPETENT.", name: 'competent', labels: likert_scale, required: true},
        {prompt: "The speaker is EASYGOING.", name: 'easygoing', labels: likert_scale, required: true}
    ],
    randomize_question_order: true,
};
timeline.push(trials);

jsPsych.run(timeline);