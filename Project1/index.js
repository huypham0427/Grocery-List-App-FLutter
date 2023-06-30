/** 
  --- I used "keypress" module to detect the key press. 
  Usage: npm install keypress
  --- Firstly, it will fetch the resource from the URL. It checks if the URL is valid or not 
  --- Next, printResource(), it will take the URL as an argument and prints the resource to console. 
  It can check if the resource is text or not. If not, it will "preceded by file offset in hex"
 --- Increase/decrease the display speed. I can't use the "+" and "-". Therefore, I replace them as "f"-faster and "s"-slower. 

*/

const http = require("http");
const https = require("https");
const readline = require("readline");
const keypress = require("keypress");

const printResource = async (url) => {
  const protocol = url.startsWith("https") ? https : http;

  const response = await protocol.get(url);

  const chunks = [];
  response.on("data", (chunk) => {
    chunks.push(chunk);
  });
  response.on("end", () => {
    const data = Buffer.concat(chunks);
    const resource = data.toString();

    const isTextResource = /^[\x00-\x7F]*$/.test(resource);

    if (isTextResource) {
      // Text resource
      const lines = resource.split("\n");
      const printLine = (lineNumber, line) => {
        console.log(`${lineNumber}: ${line}`);
      };

      const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout,
      });

      rl.on("keypress", (_, key) => {
        // Decrease the display speed
        if (key && key.name === "f") {
          clearInterval(interval);
          printResource(url, speed / 2);

          // Increase the display speed
        } else if (key && key.name === "s") {
          clearInterval(interval);
          printResource(url, speed * 2);

          // Pause the display
        } else if (key && key.name === "space") {
          paused = !paused;
        }
      });

      let lineNumber = 1;
      let interval = setInterval(() => {
        if (paused) return;

        printLine(lineNumber, lines[lineNumber - 1]);
        lineNumber++;

        if (lineNumber >= lines.length) {
          clearInterval(interval);
        }
      }, speed);
    } else {
      // Binary resource
      const offset = 0;
      const index = 0;
      const printChunk = (chunk) => {
        const hexBytes = Array.from(chunk, (byte) => byte.toString(16).padStart(2, "0")).join(" ");

        console.log(`${offset.toString(16).padStart(8, "0")}: ${hexBytes}`);
        offset += 16;
        index += 16;
      };

      const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout,
      });

      rl.on("keypress", (_, key) => {
        // Increase the display speed
        if (key && key.name === "f") {
          clearInterval(interval);
          printResource(url, speed / 2);

          // Decrease the display speed
        } else if (key && key.name === "s") {
          clearInterval(interval);
          printResource(url, speed * 2);

          // Pause the display
        } else if (key && key.name === "space") {
          paused = !paused;
        }
      });

      let interval = setInterval(() => {
        if (paused) return;

        printChunk(resource.slice(index, index + 16));
        index += 16;

        if (index >= resource.length) {
          clearInterval(interval);
        }
      }, speed);
    }
  });
};

// Get URL from command line argument
const url = process.argv[2];
if (!url) {
  console.error("Please provide a URL as an argument.");
} else {
  printResource(url);
}
