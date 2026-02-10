import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  static values = { url: String }

  connect() { 
    this.initSelect()
  }

  initSelect() {
    this.ts = new TomSelect(this.element, {
      valueField: 'id',
      labelField: 'name',
      searchField: ['name'],
      preload: 'focus',
      load: (query, callback) => {
        this.fetchOptions(query, callback)
      },
      onFocus: () => {
        this.ts?.open()
      },
      render: {
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

  fetchOptions(query, callback) {
    const q = query || ""
    const url = `${this.urlValue}?q=${encodeURIComponent(q)}`
    fetch(url)
      .then(response => response.json())
      .then(json => {
        callback(json);
      }).catch(()=>{
        callback();
      });
  }
  disconnect() {
    this.ts?.destroy()
  }
}
