const path = require('path');
const axios = require('axios');
const jetpack = require('fs-jetpack');
const _ = require('lodash');

const savepath = './gists';
const url = 'https://api.github.com/users/etienne-dldc/gists';

jetpack.remove(savepath);

axios.get(url).then(({ data }) => {
  data.forEach(function(gist) {

    console.log('description: ', gist.description);
    var dir = savepath + '/' + gist.description;

    jetpack.dir(dir);
    _.each(gist.files, (file, filename) => {
      var raw_url = file.raw_url;

      console.log('downloading... ' + filename);
      axios({
        method: 'get',
        url: raw_url,
        responseType: 'stream',
      }).then(response => {
        console.log(filename);
        response.data.pipe(jetpack.createWriteStream(dir + '/' + filename));
      });
    })
  });
});
