let trial_objects = [
    {
        "stimulus": "audio/F1_01.wav",
        "clip": "F1_01",
        "speaker": "F1"
    },
    {
        "stimulus": "audio/F1_02.wav",
        "clip": "F1_02",
        "speaker": "F1"
    },
    {
        "stimulus": "audio/F1_03.wav",
        "clip": "F1_02",
        "speaker": "F1"
    },
    // {
    //     "stimulus": "audio/F1_04.wav",
    //     "clip": "F1_02",
    //     "speaker": "F1"
    // },
    // {
    //     "stimulus": "audio/F2_01.wav",
    //     "clip": "F2_01",
    //     "speaker": "F2"
    // },
    // {
    //     "stimulus": "audio/F2_02.wav",
    //     "clip": "F2_02",
    //     "speaker": "F2"
    // },
    // {
    //     "stimulus": "audio/F2_03.wav",
    //     "clip": "F2_03",
    //     "speaker": "F2"
    // },
    // {
    //     "stimulus": "audio/F2_04.wav",
    //     "clip": "F2_04",
    //     "speaker": "F2"
    // },
    // {
    //     "stimulus": "audio/F3_01.wav",
    //     "clip": "F3_01",
    //     "speaker": "F3"
    // },
    // {
    //     "stimulus": "audio/F3_02.wav",
    //     "clip": "F3_02",
    //     "speaker": "F3"
    // },
    // {
    //     "stimulus": "audio/F3_03.wav",
    //     "clip": "F3_03",
    //     "speaker": "F3"
    // },
    // {
    //     "stimulus": "audio/F3_04.wav",
    //     "clip": "F3_04",
    //     "speaker": "F3"
    // },
    // {
    //     "stimulus": "audio/F4_01.wav",
    //     "clip": "F4_01",
    //     "speaker": "F4"
    // },
    // {
    //     "stimulus": "audio/F4_02.wav",
    //     "clip": "F4_02",
    //     "speaker": "F4"
    // },
    // {
    //     "stimulus": "audio/F4_03.wav",
    //     "clip": "F4_03",
    //     "speaker": "F4"
    // },
    // {
    //     "stimulus": "audio/F4_04.wav",
    //     "clip": "F4_04",
    //     "speaker": "F4"
    // },
    // {
    //     "stimulus": "audio/F5_01.wav",
    //     "clip": "F5_01",
    //     "speaker": "F5"
    // },
    // {
    //     "stimulus": "audio/F5_02.wav",
    //     "clip": "F5_02",
    //     "speaker": "F5"
    // },
    // {
    //     "stimulus": "audio/F5_03.wav",
    //     "clip": "F5_03",
    //     "speaker": "F5"
    // },
    // {
    //     "stimulus": "audio/F5_04.wav",
    //     "clip": "F5_04",
    //     "speaker": "F5"
    // },
    // {
    //     "stimulus": "audio/M1_01.wav",
    //     "clip": "M1_01",
    //     "speaker": "M1"
    // },
    // {
    //     "stimulus": "audio/M1_02.wav",
    //     "clip": "M1_02",
    //     "speaker": "M1"
    // },
    // {
    //     "stimulus": "audio/M1_03.wav",
    //     "clip": "M1_03",
    //     "speaker": "M1"
    // },
    // {
    //     "stimulus": "audio/M1_04.wav",
    //     "clip": "M1_04",
    //     "speaker": "M1"
    // },
    // {
    //     "stimulus": "audio/M2_01.wav",
    //     "clip": "M2_01",
    //     "speaker": "M2"
    // },
    // {
    //     "stimulus": "audio/M2_02.wav",
    //     "clip": "M2_02",
    //     "speaker": "M2"
    // },
    // {
    //     "stimulus": "audio/M2_03.wav",
    //     "clip": "M2_03",
    //     "speaker": "M2"
    // },
    // {
    //     "stimulus": "audio/M2_04.wav",
    //     "clip": "M2_04",
    //     "speaker": "M2"
    // },
    // {
    //     "stimulus": "audio/M3_01.wav",
    //     "clip": "M3_01",
    //     "speaker": "M3"
    // },
    // {
    //     "stimulus": "audio/M3_02.wav",
    //     "clip": "M3_02",
    //     "speaker": "M3"
    // },
    // {
    //     "stimulus": "audio/M3_03.wav",
    //     "clip": "M3_03",
    //     "speaker": "M3"
    // },
    // {
    //     "stimulus": "audio/M3_04.wav",
    //     "clip": "M3_04",
    //     "speaker": "M3"
    // },
    // {
    //     "stimulus": "audio/M4_01.wav",
    //     "clip": "M4_01",
    //     "speaker": "M4"
    // },
    // {
    //     "stimulus": "audio/M4_02.wav",
    //     "clip": "M4_02",
    //     "speaker": "M4"
    // },
    // {
    //     "stimulus": "audio/M4_03.wav",
    //     "clip": "M4_03",
    //     "speaker": "M4"
    // },
    // {
    //     "stimulus": "audio/M4_04.wav",
    //     "clip": "M4_04",
    //     "speaker": "M4"
    // },
    // {
    //     "stimulus": "audio/M5_01.wav",
    //     "clip": "M5_01",
    //     "speaker": "M5"
    // },
    // {
    //     "stimulus": "audio/M5_02.wav",
    //     "clip": "M5_02",
    //     "speaker": "M5"
    // },
    // {
    //     "stimulus": "audio/M5_03.wav",
    //     "clip": "M5_03",
    //     "speaker": "M5"
    // },
    // {
    //     "stimulus": "audio/M5_04.wav",
    //     "clip": "M5_04",
    //     "speaker": "M5"
    // },
    // {
    //     "stimulus": "attention_check_01",
    //     "clip": "stronglyagree",
    //     "speaker": "attention_check"
    // },
    // {
    //     "stimulus": "attention_check_02",
    //     "clip": "agree",
    //     "speaker": "attention_check"
    // },
    // {
    //     "stimulus": "attention_check_03",
    //     "clip": "somewhatdisagree",
    //     "speaker": "attention_check"
    // },
    // {
    //     "stimulus": "attention_check_04",
    //     "clip": "neutral",
    //     "speaker": "attention_check"
    // }
]