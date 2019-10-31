import { Lambda } from 'aws-sdk';

const lambdaClient = new Lambda({
  region: 'us-east-1',
  endpoint: "http://172.17.0.1:4574"
});

export const handler = async () => {
  console.log('test2');

  await lambdaClient.invoke({
    FunctionName: 'lambda1'
  }).promise();

};