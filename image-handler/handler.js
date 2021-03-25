'use strict';

const AWS = require('aws-sdk');
const S3 = new AWS.S3();

module.exports.upload = async (event) => {
  const imageName = Math.random().toString(36).substring(7)
  await S3.putObject({
    Bucket: process.env.IMAGES_BUCKET,
    Key: `uploads/${imageName}.jpg`,
    Body: Buffer.from(event.body.replace(/^data:image\/\w+;base64,/, ""),'base64'),
    ContentEncoding: 'base64',
    ContentType: 'image/jpeg'
  }).promise();
  return {
    statusCode: 201,
    body: JSON.stringify(
      {
        message: 'Upload realizado com sucesso',
        imagem: imageName,
      }),
  };
};

module.exports.download = async (event) => {
  const s3Object = await S3.getObject({
    Bucket: process.env.IMAGES_BUCKET,
    Key: `processed/${event.pathParameters.id}.jpg`,
  }).promise();
  console.log(s3Object.Body);
    return {
      statusCode: 200,
      headers: {
        "Content-Type": "image/jpeg"
      },
      isBase64Encoded: true,
      body: s3Object.Body.toString('base64')
  };
};
