function evaluate_response(data) {
        if (data.response == 'd' & data.correct == 'NEW') {
            data.result = "correct_rejection"
        } else if (data.response == 'k' & data.correct == 'NEW') {
            data.result = "false_alarm"
        } else if (data.response == 'd' & data.correct == 'OLD') {
            data.result = "miss"
        } else  {
            data.result = "hit"
        }
    }