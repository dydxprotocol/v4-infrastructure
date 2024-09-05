import json
import logging

from typing import Any

import boto3
import requests

S3_BUCKET = 'market-metadata'
S3_INFO_OBJECT_KEY = 'info.json'
S3_QUOTE_OBJECT_KEY = 'quote.json'

CMC_API_KEY = ''
CMC_BASE_API_URL = 'https://pro-api.coinmarketcap.com'
CMC_INFO_API_URL = CMC_BASE_API_URL + '/v2/cryptocurrency/info'
CMC_QUOTES_API_URL = CMC_BASE_API_URL + '/v2/cryptocurrency/quotes/latest'
CMC_OHLCV_API_URL = CMC_BASE_API_URL + '/v2/cryptocurrency/ohlcv/historical'
CMC_BASE_TOKEN_PAGE_URL = 'https://coinmarketcap.com/currencies'

ASSET_TO_ID = {
    'BTC': 1,
    'ETH': 1027,
    'SOL': 5426,
    'DOGE': 74,
    'PEPE': 24478,
    'W': 29587,
    'MANA': 1966,
    'LPT': 3640,
    'GLM': 1455,
    'HNT': 5665,
}

ID_TO_ASSET = {
    1: 'BTC',
    1027: 'ETH',
    5426: 'SOL',
    74: 'DOGE',
    24478: 'PEPE',
    29587: 'W',
    1966: 'MANA',
    3640: 'LPT',
    1455: 'GLM',
    5665: 'HNT',
}


logger = logging.getLogger()
logger.setLevel(logging.DEBUG)


def init_session() -> requests.Session:
    headers = {
        'Accepts': 'application/json',
        'Accept-Encoding': 'deflate, gzip',
        'X-CMC_PRO_API_KEY': CMC_API_KEY
    }
    session = requests.Session()
    session.headers.update(headers)
    return session


def make_get_request(session: requests.Session, url: str, params: Any) -> Any:
    # TODO Handle errors, check 'status' field of response
    try:
        response = session.get(url, params=params)
        data = json.loads(response.text)
    except (ConnectionError, Timeout, TooManyRedirects) as e:
        print(e)

    return data


def fetch_info(session: requests.Session, params: Any) -> Any:
    data = make_get_request(session, CMC_INFO_API_URL, params)

    res = {}
    for cmc_id, cmc_data in data['data'].items():
        res[ID_TO_ASSET[int(cmc_id)]] = {
            'name': cmc_data['name'],
            'logo': cmc_data['logo'],
            'urls': {
                # CMC returns a list of URLs for each category. For now, just take the first one
                'website': cmc_data['urls']['website'][0] if cmc_data['urls']['website'] else None,
                'technical_doc': cmc_data['urls']['technical_doc'][0] if cmc_data['urls']['technical_doc'] else None,
                'cmc': CMC_BASE_TOKEN_PAGE_URL + '/' + cmc_data['slug']
            },
            'sector_tags': cmc_data['tags'],
            'exchanges': []
        }

    return res


def fetch_quotes(session: requests.Session, params: Any) -> Any:
    data = make_get_request(session, CMC_QUOTES_API_URL, params)

    res = {}
    for cmc_id, cmc_data in data['data'].items():
        quote = cmc_data['quote']['USD']
        res[ID_TO_ASSET[int(cmc_id)]] = {
            'price': quote['price'],
            'percent_change_24h': quote['percent_change_24h'],
            'volume_24h': quote['volume_24h'],
            'market_cap': quote['market_cap'],
        }

    return res


def write_to_s3(object_key: str, data: Any):
    client = boto3.client('s3')
    client.put_object(
        Body=json.dumps(data),
        Bucket=S3_BUCKET,
        Key=object_key
    )


def main(run_type: str, ids: list[str]):
    session = init_session()
    params = {
        'id': ','.join([str(x) for x in ASSET_TO_ID.values()])
    }

    info_data = fetch_info(session, params)
    write_to_s3(S3_INFO_OBJECT_KEY, info_data)

    quotes_data = fetch_quotes(session, params)
    write_to_s3(S3_QUOTE_OBJECT_KEY, quotes_data)


def lambda_handler(event, context):
    main(None, None)


if __name__ == "__main__":
    main(None, None)
