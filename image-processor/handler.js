'use strict';

const AWS = require('aws-sdk');
const S3 = new AWS.S3();
const jimp = require('jimp');

module.exports.process = async (event) => {
  for (let record of event.Records) {
    const s3Object = await S3.getObject({
      Bucket: record.s3.bucket.name,
      Key: record.s3.object.key
    }).promise();
    console.log('Objeto do S3 lido com sucesso');
    const buffer = await jimp.read(s3Object.Body);
    const imagemComFiltroAplicado = await buffer.greyscale().quality(80).getBufferAsync(jimp.MIME_JPEG);
    console.log('Filtro aplicado');
    await S3.putObject({
      Bucket: process.env.IMAGES_BUCKET,
      Key: `processed/${record.s3.object.key.split('/')[1]}`,
      Body: imagemComFiltroAplicado
    }).promise();
    console.log('Fim do processamento de imagem');
  }
  return { };
};
