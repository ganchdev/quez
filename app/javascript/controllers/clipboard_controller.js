import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  copy(e) {
    e.preventDefault();
    e.currentTarget.blur();

    navigator.clipboard.writeText(e.currentTarget.href)
      .then(() => {
        const flashDiv = document.createElement("div");
        flashDiv.className = "flash notice";
        flashDiv.setAttribute("data-controller", "flashes");
        flashDiv.textContent = "Game link has been copied";
        document.body.appendChild(flashDiv);
      })
      .catch(err => {
        console.error("Failed to copy: ", err);
      });
  }
}
