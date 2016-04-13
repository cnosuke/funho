class Pomodoro {
  constructor(obj) {
    this.pomodoro_id = obj.pomodoro_id;
    this.running = obj.running;
    this.remainning = obj.remainning;
    this.csrf_token = obj.csrf_token;
    this.get_notification_permission();
  }

  run() {
    if(!this.running){ return 0 };

    setTimeout(() => {
      this.update_remainning();
      if(this.running){
        this.run()
      }else{
        this.finish_pomodoro();
      }
    }, 1000);
  }

  finish_pomodoro() {
    this.notice("💮💮 Pomodoro finished 💮💮");
    this.write_remainning("💮FINISH💮");
    this.hide_stop_button();
    this.sending_stop();
  }

  notice(message) {
    new Notification(message)
  }

  time_str() {
    var m = this.remainning / 60;
    var s = this.remainning % 60;
    return `${Math.trunc(m)}m ${s}s`;
  }

  update_remainning() {
    this.decrement_remainning();
    this.write_remainning(this.time_str());
  }

  decrement_remainning() {
    this.remainning = this.remainning - 1;

    if(this.remainning < 0) {
      this.running = false;
    }
  }

  write_remainning(str) {
    var el = document.getElementById('pomodoro_remainning');
    el.innerHTML = str;
  }

  hide_stop_button() {
    var el = document.getElementById('main_button')
    el.classList.add('hidden');
  }

  sending_stop() {
    var form_data = new FormData();
    form_data.append("authenticity_token", this.csrf_token);
    form_data.append("pomodoro_id", this.pomodoro_id);

    var xhr = new XMLHttpRequest();
    var url = `/pomodoros/${this.pomodoro_id}/stop.json`;
    xhr.open("POST", url, true);
    xhr.onreadystatechange = () => {
      switch (xhr.readyState) {
        case 4:
          if (xhr.status == 0) {
            console.error('XHR failed:')
            console.error(xhr);
          }else if(xhr.status == 200){
            this.get_success_xhr(xhr.responseText)
          }
          break;
      }
    }
    xhr.send(form_data);
  }

  get_success_xhr(text) {
    var obj = JSON.parse(text);
    if(obj.status == 'success'){
      console.info('Successfully finished.')
    }else{
      alert('Unknown error: ' + obj.status);
    }
  }

  get_notification_permission() {
    Notification.requestPermission(function(result) {
      if (result === 'denied') {
        console.info('Notification permission denied.');
      } else if (result === 'default') {
        console.info('Notification permssion is default.');
      } else if (result === 'granted') {
        console.info('Notification permission granted.');
      }
    })
  }
}
