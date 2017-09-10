
const path = require('path');
const axios = require('axios');
const jetpack = require('fs-jetpack');
const _ = require('lodash');

const savepath = './pens';
const collectionID = 'XzNOkB';
const url = 'https://cpv2api.com/collection/' + collectionID;

let page = 1;
let allPens = [];

function getPens() {
  const pagedUrl = url + '?page=' + page;
  console.log('get ' + pagedUrl)
  axios.get(pagedUrl).then(({ data }) => {
    if (!data.error) {
      const pens = data.data;
      allPens = allPens.concat(pens);
      page = page + 1;
      getPens();
      return;
    }

    jetpack.remove(savepath);
    jetpack.dir(savepath);
    allPens.forEach((pen) => {
      const zipUrl = `https://codepen.io/${pen.user.username}/share/zip/${pen.id}/`;
      axios({
        method: 'get',
        url: zipUrl,
        responseType: 'stream',
      }).then(response => {
        response.data.pipe(jetpack.createWriteStream(savepath + '/' + pen.title + '.zip'));
      });
    });
  });
}

getPens();

// axios.get(url).then(({ data }) => {
//   const pens = data.data;
//   jetpack.remove(savepath);
//   jetpack.dir(savepath);
//   pens.forEach((pen) => {
//     const zipUrl = `https://codepen.io/${pen.user.username}/share/zip/${pen.id}/`;
//     axios({
//       method: 'get',
//       url: zipUrl,
//       responseType: 'stream',
//     }).then(response => {
//       response.data.pipe(jetpack.createWriteStream(savepath + '/' + pen.title + '.zip'));
//     });
//   });
// });


