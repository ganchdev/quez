import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["choice"];

  submit(event) {
    const selectedRadio = this.choiceTargets.find((radio) => radio.checked);

    if (!selectedRadio) {
      console.error("No option selected, aborting submission");
      return;
    }

    this.element.requestSubmit();

    this.choiceTargets.forEach((radio) => {
      radio.disabled = true;
    });
  }
}
