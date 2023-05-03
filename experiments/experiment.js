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

const instructions = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus:  `In this experiment, you will listen to short audio clips.
    <BR><BR>After listening to each clip, please evaluate the speaker by indicating how much you agree or disagree with the provided statements.
    <BR><BR>Please press the SPACE BAR to continue.`,
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

const questionnaire = {
    type: jsPsychSurvey,
    pages: [
        [
            {
                type: 'html',
                prompt: "Please answer the following questions:"
            },
            {
                type: 'multi-choice',
                prompt: 'Did you read the instructions and do you think you did the task correctly?', 
                name: 'correct', 
                options: ['Yes', 'No', 'I was confused']
            },
            {
                type: 'drop-down',
                prompt: 'Gender:',
                name: 'gender',
                options: ['Female', 'Male', 'Non-binary/Non-conforming', 'Other']
            },
            {
                type: 'text',
                prompt: 'Age:',
                name: 'age',
                textbox_columns: 10
            },
            {
                type: 'drop-down',
                prompt: 'Level of education:',
                name: 'education',
                options: ['Some high school', 'Graduated high school', 'Some college', 'Graduated college', 'Hold a higher degree']
            },
            {
                type: 'text',
                prompt: "Native language? (What was the language spoken at home when you were growing up?)",
                name: 'language',
                textbox_columns: 20
            },
            {
                type: 'drop-down',
                prompt: 'Do you think the payment was fair?',
                name: 'payment',
                options: ['The payment was too low', 'The payment was fair']
            },
            {
                type: 'drop-down',
                prompt: 'Did you enjoy the experiment?',
                name: 'enjoy',
                options: ['Worse than the average experiment', 'An average experiment', 'Better than the average experiment']
            },
            {
                type: 'text',
                prompt: "Do you have any other comments about this experiment?",
                name: 'comments',
                textbox_columns: 30,
                textbox_rows: 4
            }
        ]
    ]
};
timeline.push(questionnaire);

/* future study? */
var futurestudies = {
  type: jsPsychSurvey,
  pages: [
    [
      {
        type: 'multi-choice',
        prompt: "Do you consent to being contacted for future studies?",
        name: 'futurestudies',
        options: ['Yes', 'No'],
        required: true,
      }
    ]
  ],
  button_label_finish: 'Continue',
};
timeline.push(futurestudies);

/* payment information */
var payment = {
  type: jsPsychSurveyText,
  questions: [
    {
      prompt: `
            <div class="text" id="trial">
            <p>Please provide your email address in the field below for participant reimbursement purposes.</p>
            </div>
            `,
      name: 'payment'
    }
  ]
};
timeline.push(payment);

/* thank you */
const thanks = {
    type: jsPsychHtmlButtonResponse,
    choices: ['Submit'],
    stimulus: `<p>Thank you for completing the experiment!</p>
            <p>We will contact you soon to arrange for participant reimbursement.</p>
            <p>Please click "Submit" to submit your responses and complete the study.</p>`
}
timeline.push(thanks);

jsPsych.run(timeline);