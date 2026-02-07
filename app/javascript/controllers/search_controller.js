import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  static values = { url: String }

  connect() { 
    this.ts = new TomSelect(this.element, {
      valueField: 'id',
      labelField: 'name',
      searchField: ['name'],
      load: (query, callback) => {
        const url = `${this.urlValue}?q=${encodeURIComponent(query)}`
        fetch(url)
          .then(response => response.json())
          .then(json => {
            console.log(json)
            callback(json);
          }).catch(()=>{
            callback();
          });
      }, render: {
        option: (item, escape) => `
          <div class="py-2">
            <div class="font-medium">${escape(item.name)}</div>
            ${item.phone ? `<div class="text-xs opacity-70">${escape(item.phone)}</div>` : ""}
          </div>
        `,
        item: (item, escape) => `<div>${escape(item.name)}</div>`
      }
    })
  }
  disconnect() {
    this.ts?.destroy()
  }
}
