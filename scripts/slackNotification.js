const axios = require("axios")

const SLACK_WEBHOOK_URL = "https://hooks.slack.com/services/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"

const type = process.argv[2];
const title = process.argv[3];
const url = process.argv[4];
const logs = process.argv[5];
const currentDate = new Date()

let payload;
if (type == "SUCCESS") {
	payload = {
		attachments: [
			{
				color: "#7CD197",
				fields: [
					{
						title: null,
						value: title,
						short: false
					},					
					{
						title: null,
						value: url,
						short: false
					},																		
					{
						title: "*Last commit*:",
						value: logs,
						short: false
					}				
				],
				footer:  currentDate.toLocaleTimeString("en-US", {timeZone: "America/Los_Angeles"}) + "  -  " + currentDate.toLocaleDateString("en-US", {timeZone: "America/Los_Angeles"}),
				footer_icon: "https://platform.slack-edge.com/img/default_application_icon.png"
			}
	    ]
	}
} else {
	console.log("TODO: Add formatted message for failed builds")
}

axios.default.post(SLACK_WEBHOOK_URL, payload)
.then(data => {
	console.log(data)
	process.exit(0)
})
.catch(err => {
	console.log(err)
	process.exit(1)
})