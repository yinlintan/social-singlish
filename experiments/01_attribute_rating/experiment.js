const jsPsych = initJsPsych({
    show_progress_bar: true,
    auto_update_progress_bar: false,
    on_finish: function () {
        //jsPsych.data.displayData('csv');
        window.location = "https://yinlintan.github.io/social-singlish/experiments/01_attribute_rating/thanks.html";
        proliferate.submit({ "trials": jsPsych.data.get().values() });
      }
  });

let timeline = [];

const preload_array = trial_objects;
const preload_trial = {
    type: jsPsychPreload,
    audio: preload_array
};

const stopCollection = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: '<p>This study is currently not accepting new participants. Please check back again tomorrow.</p>',
    choices: "NO_KEYS",
};
timeline.push(stopCollection);

const irb = {
    type: jsPsychHtmlButtonResponse,
    stimulus: `
    <p style="width: 1000px; margin-bottom: -250px">
    We invite you to participate in a research study on language production and comprehension.
    <BR><BR>Your experimenter will ask you to do a linguistic task such as reading sentences or words, naming pictures or describing scenes, making up sentences of your own, or participating in a simple language game. 
    <BR><BR>There are no risks or benefits of any kind involved in this study.
    <BR><BR>You will be paid for your participation at the posted rate.
    <BR><BR>
    If you agree to participate, please proceed to the study tasks.
    </p>
    <p style="width: 1000px; font-size: 9pt; position: relative; top: 330px; padding-bottom: 30px; text-align: justify">
    If you have read this form and have decided to participate in this experiment, please understand your participation is voluntary and you have the right to withdraw your consent or discontinue participation at anytime without penalty or loss of benefits to which you are otherwise entitled. You have the right to refuse to do particular tasks. Your individual privacy will be maintained in all published and written data resulting from the study. You may print this form for your records.
    <BR><BR>CONTACT INFORMATION: If you have any questions, concerns or complaints about this research study, its procedures, risks and benefits, you should contact the Protocol Director Meghan Sumner at (650)-725-9336. If you are not satisfied with how this study is being conducted, or if you have any concerns, complaints, or general questions about the research or your rights as a participant, please contact the Stanford Institutional Review Board (IRB) to speak to someone independent of the research team at (650)-723-2480 or toll free at 1-866-680-2906. You can also write to the Stanford IRB, Stanford University, 3000 El Camino Real, Five Palo Alto Square, 4th Floor, Palo Alto, CA 94306 USA.
    </p>`,
    choices: ['Continue']
};
timeline.push(irb);

/* eligibility */
const intro1 = {
    type: jsPsychHtmlButtonResponse,
    stimulus:  `<p>Only complete this study if you are a Singaporean citizen or Singapore Permanent Resident (PR) who is 18 years old or older.</p>
            <p>Please share this link with other Singaporean citizens and Singapore PRs, but do not participate in this study more than once. You will not be compensated more than once.</p>
            <p>This experiment will take no more than 20 minutes and you will be compensated 4 SGD upon completion.</p>
            <p>Click CONTINUE to proceed.</p>`,
    choices: ['Continue'],
};
timeline.push(intro1);

/* instructions */
const intro2 = {
    type: jsPsychHtmlButtonResponse,
    stimulus:  `<p>Please make sure that you are completing this experiment in a quiet room.</p>
    <p>This experiment should be completed on a desktop or laptop using the Google Chrome browser.</p>
    <p>You should use earphones or headphones for the duration of this experiment.</p>
    <p>Click CONTINUE to proceed.</p>`,
    choices: ['Continue'],
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
    type: jsPsychHtmlButtonResponse,
    stimulus:  `<p>In this experiment, you will listen to short audio clips.</p>
    <p>These clips consist of short phrases or sentences.</p>
    <p>After listening to each clip, please indicate how much you agree or disagree with the provided statements.</p>
    <p>Click CONTINUE to proceed.</p>`,
    choices: ['Continue']
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

/* create array of stimuli and randomize stimuli*/
let tv_array = create_tv_array(trial_objects);
let stimuli = shuffle_array(tv_array);

/* create array of attributes and randomize attribute order per participant */
let raw_attributes = [
                {prompt: "The speaker is HONEST.", name: 'honest', labels: likert_scale, required: true},
                {prompt: "The speaker is ROUGH.", name: 'rough', labels: likert_scale, required: true},
                {prompt: "The speaker is CASUAL.", name: 'casual', labels: likert_scale, required: true},
                {prompt: "The speaker is EASYGOING.", name: 'easygoing', labels: likert_scale, required: true},
                {prompt: "The speaker is PROPER.", name: 'proper', labels: likert_scale, required: true},
                {prompt: "The speaker is FAST-SPEAKING.", name: 'fastspeaking', labels: likert_scale, required: true}
                ];
let attributes = shuffle_array(raw_attributes);

let filepath = function getaudio() {
    return jsPsych.timelineVariable('stimulus')
  };

let audio_path = "";
let clip_id = "";
let speaker_id = "";

/* rating trials */
const trials = {
    timeline: [
        {
            type: jsPsychAudioKeyboardResponse,
            choices: ['NO_KEYS'],
            stimulus: jsPsych.timelineVariable('stimulus'),
            response_allowed_while_playing: false,
            trial_ends_after_audio: true,
            prompt: `Listen to this audio clip.`,
            // on_finish: function(data) {
            //     evaluate_response(data);
            // },
        },
        {
            type: jsPsychSurveyLikert,
            preamble: function() {
              new_audio_path = "<audio controls src=" + '"' + jsPsych.timelineVariable('stimulus') + '"' + ">";
              return `<p>Press play to listen to the audio again.</p>
              <p>${new_audio_path}</p>
              <p>Rate how much you agree or disagree with the following statements:</p>`
            },
            questions: function() {
              return attributes
            },
            on_finish: function(data) {
              jsPsych.setProgressBar(data.trial_index/93)
            },
            data: jsPsych.timelineVariable('data')
        },
        ],
    timeline_variables: stimuli,
};
timeline.push(trials);

/* survey 1: demographic questions */
const survey1 = {
  type: jsPsychSurvey,
  pages: [
    [
      {
        type: 'html',
        prompt: `<p style="color: #000000">Please answer the following questions:</p>`,
      },
      {
        type: 'multi-choice',
        prompt: "What is your citizenship status?",
        name: 'citizenship',
        options: ['Singaporean', 'Singapore PR', 'None of the above', 'Prefer not to answer'],
        required: true
      },
      {
        type: 'multi-choice',
        prompt: "What is your gender?",
        name: 'gender',
        options: ['Male', 'Female', 'Non-binary', 'Other', 'Prefer not to answer'],
        required: false,
      },
      {
        type: 'drop-down',
        prompt: "What year were you born?",
        name: 'age',
        options: ['2005', '2004', '2003', '2002', '2001', '2000', '1999', '1998', '1997', '1996', '1995', '1994', '1993', '1992', '1991', '1990', '1989', '1988', '1987', '1986', '1985', '1984', '1983', '1982', '1981', '1980', '1979', '1978', '1977', '1976', '1975', '1974', '1973', '1972', '1971', '1970', '1969', '1968', '1967', '1966', '1965', '1964', '1963', '1962', '1961', '1960', '1959', '1958', '1957', '1956', '1955', '1954', '1953', '1952', '1951', '1950', '1949', '1948', '1947', '1946', '1945', '1944', '1943', '1942', '1941', '1940', '1939', '1938', '1937', '1936', '1935', '1934', '1933', 'Prefer not to answer'],
        required: true,
      },
      {
        type: 'multi-select',
        prompt: "What is your race? Please select all that apply.",
        name: 'race',
        options: ['Chinese', 'Malay', 'Indian', 'Other', 'Prefer not to answer'],
        required: true,
      },
      {
        type: 'text',
        prompt: "What is your estimated total monthly household income (in Singapore dollars)?",
        name: 'income',
        textbox_columns: 8,
        input_type: "number",
        required: true,
      },
      {
        type: 'multi-choice',
        prompt: "What is your highest level of education?",
        name: 'education',
        options: ['No qualification', 'Primary school', 'Secondary school', 'Junior college/Polytechnic', 'Undergraduate degree', 'Postgraduate degree', 'Prefer not to answer'],
        required: false,
      }
    ]
  ],
  button_label_finish: 'Continue',
};
timeline.push(survey1);

/* survey 2: language background questions */
const survey2a = {
  type: jsPsychSurveyHtmlForm,
  preamble: `<p>What languages do you speak?</p>
  <p>Please indicate up to 5 languages and list them <b>in order of descending frequency of use</b>, i.e., Language 1 is the most frequently spoken language, Language 2 the second-most frequently spoken language, and so on.</p>
  <p>For example, if English is Language 1, Malay is Language 2, and Hokkien is Language 3, that means you speak English the most frequently, Malay the second-most frequently, and Hokkien the least frequently.
  </p>`,
  html: `<p>
  <input name="lang1" type="text" placeholder="Language 1" required><BR><BR>
  <input name="lang2" type="text" placeholder="Language 2"><BR><BR>
  <input name="lang3" type="text" placeholder="Language 3"><BR><BR>
  <input name="lang4" type="text" placeholder="Language 4"><BR><BR>
  <input name="lang5" type="text" placeholder="Language 5">
  </p>`
};
timeline.push(survey2a);

const survey2b = {
  type: jsPsychSurvey,
  pages: [
    [
      {
        type: 'multi-choice',
        prompt: "Do you speak Singlish?",
        name: 'singlish',
        options: ['Yes', 'No'],
        required: true,
      },
      {
        type: 'text',
        prompt: "How many hours a day do you spend interacting in Singlish?",
        name: 'singlish_hours',
        input_type: "number",
        required: true,
      },
      {
        type: 'multi-choice',
        prompt: "Do your friends speak Singlish?",
        name: 'singlish_friends',
        options: ['Yes', 'No'],
        required: true,
      },
      {
        type: 'likert',
        prompt: "How often do your friends speak Singlish?",
        name: 'singlish_friends_frequency',
        required: true,
        likert_scale_min_label: 'Never',
        likert_scale_max_label: 'All the time',
        likert_scale_values: [
          { value: 1 },
          { value: 2 },
          { value: 3 },
          { value: 4 },
          { value: 5 }
        ]
      },
      {
        type: 'multi-choice',
        prompt: "Does your family speak Singlish?",
        name: 'singlish_family',
        options: ['Yes', 'No'],
        required: true,
      },
      {
        type: 'likert',
        prompt: "How often does your family speak Singlish?",
        name: 'singlish_family_frequency',
        required: true,
        likert_scale_min_label: 'Never',
        likert_scale_max_label: 'All the time',
        likert_scale_values: [
          { value: 1 },
          { value: 2 },
          { value: 3 },
          { value: 4 },
          { value: 5 }
        ]
      },
    ],
  ],
  button_label_finish: 'Continue',
};
timeline.push(survey2b);

/* survey 3: open-ended singlish questions

const survey3a = {
  type: jsPsychSurveyHtmlForm,
  preamble: '<p>List three attributes to describe the speakers that sounded more Singlish:</p>',
  html: '<p><input name="word1" class="try" type="text" placeholder="Word 1" required><BR><BR><input name="word2" type="text" placeholder="Word 2" required><BR><BR><input name="word3" type="text" placeholder="Word 3" required></p>'
};
timeline.push(survey3a);
*/

const survey3b = {
  type: jsPsychSurvey,
  pages: [
    [
      {
        type: 'text',
        prompt: "In your opinion, when and/or where is it acceptable to use Singlish? When and/or where is it not acceptable to use Singlish?",
        name: 'singlish_acceptability',
        required: true,
      },
      {
        type: 'text',
        prompt: "What is Singlish? Give a definition.",
        name: 'singlish_definition',
        required: true,
      },
      {
        type: 'multi-choice',
        prompt: "How important do you think Singlish is?",
        name: 'singlish_important',
        options: ['Very important', 'Important', 'Neutral', 'Not important', 'Not important at all'],
        required: true,
      }
    ]
  ],
  button_label_finish: 'Continue',
};
timeline.push(survey3b);

/* survey 4: language attitude questions */
var likert_scale_singlish = [
  "Strongly Disagree",
  "Disagree",
  "Neutral",
  "Agree",
  "Strongly Agree"
];

const survey4 = {
  type: jsPsychSurveyLikert,
  preamble: `Please rate how much you agree or disagree with the following statements.`,
  questions: [
    { prompt: "Singlish is just bad English.", name: 'likert_badenglish', labels: likert_scale_singlish, required: true },
    { prompt: "Singlish is the only thing that really makes us Singaporean.", name: 'likert_singaporean', labels: likert_scale_singlish, required: true },
    { prompt: "Singlish unites the different races of Singapore.", name: 'likert_race', labels: likert_scale_singlish, required: true },
    { prompt: "It would be better for Singapore if Singlish did not exist.", name: 'likert_exist', labels: likert_scale_singlish, required: true },
  ],
  randomize_question_order: true,
};
timeline.push(survey4);

/* emotion scale */
var emotion = {
  type: jsPsychSurveyLikert,
  scale_width: 700,
  questions: [
    {
      prompt: `
      <p style="font-weight: 500">How do you feel right now? Please indicate how you are feeling using the following scale.</p>
      <center><img src="images/emotionscale.png"></center>
      `, 
      labels: [
        "1", 
        "2", 
        "3", 
        "4", 
        "5"
      ]
    }
  ]
};
timeline.push(emotion);

/* feedback about the study */
const study_feedback = {
  type: jsPsychSurvey,
  pages: [
    [
      {
        type: 'multi-choice',
        prompt: "Did you participate in the previous Singlish study (located at https://bit.ly/stanfordsinglish)?",
        name: 'previous_study',
        options: ['Yes', 'No', 'I am not sure'],
        required: true,
      },
      {
        type: 'multi-choice',
        prompt: 'Did you read the instructions and do you think you did the task correctly?',
        name: 'instructions_correct',
        options: ['Yes', 'No', 'I was confused']
      },
      {
        type: 'drop-down',
        prompt: 'Do you think the payment was fair?',
        name: 'fair',
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
        prompt: 'Do you have any other comments about this experiment?',
        name: 'comments',
        textbox_columns: 30,
        textbox_rows: 4
      }
    ]
  ],
  button_label_finish: 'Continue',
};
timeline.push(study_feedback);

/* payment information */
const payment = {
  type: jsPsychSurveyText,
  questions: [
    {
      prompt: `
            <p>Please provide your email address in the field below for participant reimbursement purposes.</p>
            `,
      name: 'payment'
    }
  ]
};
timeline.push(payment);

/* future study? */
const futurestudies = {
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

/* thank u */
const thankyou = {
  type: jsPsychHtmlButtonResponse,
  stimulus: `
            <p>Thank you for completing the experiment!</p>
            <p>We will contact you soon to arrange for participant reimbursement.</p>
            <p>Please click the "Submit" button to submit your responses and complete the study.</p>
      `,
  choices: ["Submit"],
};
timeline.push(thankyou);

jsPsych.run(timeline);