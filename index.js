const server = require('./server');

const port = process.env.PORT || 3000;
server.listen(port, () => {
  // eslint-disable-next-line no-console
  console.log('UP AND RUNNING @', port);
  console.log('JUST ANOTHER LINE!');
  console.log('JUST ANOTHER LINE!');
  console.log('TEST AGAIN!');
  console.log('TEST AGAIN!');
});
