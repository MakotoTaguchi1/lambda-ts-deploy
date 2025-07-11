import axios from 'axios';

export const handler = async (event: any): Promise<any> => {
  try {
    console.log('Lambda function started');
    
    // 環境変数からURLを取得
    const urlToGet = process.env["URL_TO_GET"];
    console.log('Target URL:', urlToGet);
    
    // 環境変数で指定されたURLにGETリクエストを送信
    const response = await axios.get(urlToGet, {
      timeout: 5000,
      headers: {
        'User-Agent': 'AWS-Lambda-TypeScript'
      }
    });
    
    console.log('Google response status:', response.status);
    console.log('Response headers:', response.headers);
    
    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        message: 'Successfully fetched URL',
        status: response.status,
        contentLength: response.data.length,
        timestamp: new Date().toISOString()
      })
    };
    
  } catch (error) {
    console.error('Error occurred:', error);
    
    return {
      statusCode: 500,
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        message: 'Error occurred while fetching data',
        error: error instanceof Error ? error.message : 'Unknown error',
        timestamp: new Date().toISOString()
      })
    };
  }
}; 