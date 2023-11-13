---
title: ByTrade API documentation

language_tabs: # must be one of https://git.io/vQNgJ
  - shell

search: False
---

# Introduction

## API Introduction

Welcome to use ByTrade API！ You can use this API get market information, trading and managing your account.

The code will display on the right side of this document. Currently we only provide "shell" code examples.

It can be accessed using the following domain names: spot.bytrade.io

Welcome all professional maker strategies and organizations for long term market making program.

## Public API
Verification free for below portals:

API|Introduction|Trading area|
----------------------|---------------------|---------------------|
[GET /open/v1/tickers/market](#all-trading-pairs-2)  |All trading pairs|Spot|
[GET /open/v1/depth/market](#depth)  |Depth|Spot|
[GET /open/v1/trade/market](#each-filled-orders-2)  |Each filled orders|Spot|
[GET /open/v1/kline/market](#market-k-line-2)  |Market K line data|Spot|

## Verified API
Eligible to access portals:

API|Introduction|Trading area|
----------------------|---------------------|---------------------|
[GET /open/v1/tickers](#all-trading-pairs)  |All or one trading pair|Spot|
[GET /open/v1/balance](#account-balance)  |Balance|Spot|
[GET /open/v1/timestamp](#server-time-stamp)  |Server time stamp|Spot|
[GET /open/v1/kline](#market-k-line)  |Market K line data|Spot|
[GET /open/v1/depth](#market-depth)  |Market depth data|Spot|
[GET /open/v1/tickers/trade](#get-last-5-trade-orders)  |Get last 5 trade orders|Spot|
[POST /open/v1/orders/place](#place-new-order)  |Place new order|Spot|
[POST /open/v1/orders/cancel](#cancel-an-order-in-order)  |Cancel an order in order|Spot|
[POST /open/v1/orders/batcancel](#cancel-all-or-part-of-the-orders-in-order)  |Cancel all or part of the orders in order|Spot|
[GET /open/v1/orders/last](#active-orders)  |Active orders|Spot|
[GET /open/v1/orders](#order-history)  |Order history|Spot|
[GET /open/v1/orders/detail](#get-order-details)  |Get an order details|Spot|
[GET /open/v1/orders/detailmore](#paging-to-get-order-details)  |Paging to get order details|Spot|
[GET /open/v1/orders/fee-rate](#get-the-user-39-s-transaction-fee-for-a-certain-transaction-pair)  |Get the user's transaction fee for a certain transaction pair|Spot|

# Connection Guide

## Restful Host:
    https://spot.bytrade.io

## Websocket Host:
    Spot
    wss://spot.bytrade.io/ws


## Verification Notice
1. All portals need to conduct verification. Parameters are "client_id","ts","nonce","sign". "client_id" is the api key. "client_key" is the secret key. Please be careful.
2. Ts is the current time stamp. Query with more than 5 seconds time difference will be rejected. "nonce" is a random code that should not be the same with last time query. 
3. Signature method: link "client_id","ts","nonce" in correct order, use hmac-sha256 to sign. e.g. the unsigned code: client_id=abc&nonce=xyz&ts=1571293029
4. Signature: sign = hmac.New(client_key, sign_str, sha256)
5. Content-Type: application/x-www-form-urlencoded
6. Please put the parameters in the request body for the post interface request, and carry the get interface request in the url link


# WebSocket Guide
1. Need verification before subscription
2. Verification method: {"op":"apilogin","sign":"","client_id":"","nonce":"","ts": int type}, e.g: {"op":"apilogin","sign":"abc123","client_id":"abc123","nonce":"1","ts": 1576207749}
3. Client need to timely upload arbitrary code to check. Server will check status every 30 seconds. Links will be closed if no information received. {"op":"sub", "topic":"hb"}

## Subscription Topic 
    {"op":"sub", "topic": ""}

### K Line Data
#### Request parameters
```json
{"op":"sub", "topic": "kline:1Min:BTT-USDT"}
```
|Parameter|Description|
|:---:|:---:|
|kline:1Min:BTT-USDT|BTT-USDT 1 minute K line|

> Responds:

```json
{
    "symbol":"BTT-USDT",
    "ticks":[
        {
            "close":"2.62",
            "high":"3.11",
            "low":"2.62",
            "open":"3.01",
            "timestamp":1572851100,
            "volume":"17.55"
        }
    ],
    "timestamp":1572851160917,
    "topic":"kline:1Min:BTT-USDT",
    "type":"60000"
}
```
#### Data refresh string list
|Field name|Data Type|     Description     |
|:-----:|:------:|:-------------------:|
|symbol|string|        Pair         |
|ticks|object|     K line Data     |
|close|string|  Local close price  |
|high|string| Local highest price |
|low|string| Local lowest price  |
|open|string|  Local open price   |
|timestamp|integer|    Time Stamp ms    |
|volume|string|       Volume        |

### Each filled orders
#### Request parameters
```json
{"op":"sub", "topic": "trade:BTT-USDT"}
```
|Parameter|Description|
|:---:|:---:|
|trade:BTT-USDT|BTT-USDT Each filled orders|

> Responds:

```json
{
    "amount":"7.473",
    "price":"2.82",
    "side":1,
    "symbol":"BTT-USDT",
    "timestamp":1572851197910,
    "topic":"trade:BTT-USDT",
    "volume":"2.65"
}
```

#### Data refresh string list

|Field name|Data Type|Description|
|:-----:|:------:|:----:|
|amount|string|Volume|
|price|string|Price|
|side|integer|Direction，1 buy，-1 sell|
|symbol|string|Pair|
|timestamp|integer|Time Stamp ms|
|volume|string|Volume|


### Depth change
#### Request parameters
```json
{"op":"sub", "topic": "depth:0:BTT-USDT"}
```
|Parameter|Description|
|:---:|:---:|
|depth:0:BTT-USDT|Depth|

> Responds:

```json
{
    "bids": [
        {'price': '2.923', 'quantity': '12'}
    ], 
    "asks": [
        {'price': '3.05', 'quantity': '3.48'}
    ],
    "symbol":"BTT-USDT",
    "timestamp":1572851208935,
    "topic":"depth:0:BTT-USDT"
}
```

#### Data refresh string list

|Field name|Data Type|Description|
|:-----:|:------:|:----:|
|bids|object|Current all buy orders[{price, quantity}]|
|asks|object|Current all sell orders[{price, quantity}]|


### Market information change
#### Request parameters
```json
{"op":"sub", "topic": "quotes"}
```
|Parameter|Description|
|:---:|:---:|
|quotes|Market Information|

> Responds:

```json
{
    "amount":"52080.1255",
    "change":"0.00949367",
    "price":"3.19",
    "symbol":"BTT-USDT",
    "timestamp":1572851216950,
    "topic":"quotes",
    "volume":"17965.65"
}
```
#### Data refresh string list

|Field name|Data Type|Description|
|:-----:|:------:|:----:|
|amount|string|Amount|
|change|string|Change|
|price|string|Current price|
|symbol|string|Pair|
|timestamp|integer|Time Stamp ms|
|volume|string|Volume|

### Account balance change
#### Request parameters
```json
{"op":"sub", "topic": "accounts"}
```
|Parameter|Description|
|:---:|:---:|
|accounts|Account balance change|

> Responds:

```json
{
    "available":"4194.3466678",
    "freeze":"71.609185",
    "symbol":"USDT",
    "topic":"accounts",
    "total":"4265.9558528"
}
```
#### Data refresh string list

|Field name|Data Type|Description|
|:-----:|:------:|:----:|
|available|string|Available balance|
|freeze|string|Locked balance|
|symbol|string|Coin|
|total|string|Total balance|

### Order Change
#### Request parameters
```json
{"op":"sub", "topic": "orders:BTT-USDT"}
```
|Parameter|Description|
|:---:|:---:|
|orders:BTT-USDT|Order Change|

> Responds:

```json
// Place new order
{
    "left":"1",
    "order_id":"11574948935833473",
    "order_type":1,
    "price":"80000",
    "quantity":"1",
    "side":-1,
    "status":2,
    "symbol":"BTT-USDT",
    "timestamp":1574949805841,
    "topic":"orders:BTT-USDT",
    "trade_no":"499081745280826070655",
    "match_qty":"0",
    "match_price":"0"
}

// Cancel order
{
    "left":"0",
    "order_id":"11574948935833473",
    "order_type":1,
    "price":"80000",
    "quantity":"1",
    "side":-1,
    "status":6,
    "symbol":"BTT-USDT",
    "timestamp":1574949805841,
    "topic":"orders:BTT-USDT",
    "trade_no":"499081745280826070655",
    "match_qty":"0",
    "match_price":"0"
}
```

#### Response Content

|Field name|Data Type|Description|
|:-----:|:------:|:----:|
|left|string|Remaining number|
|order_id|string|Order id|
|order_type|int|Order Type,1 Limit，3 Market|
|price|string|Price|
|quantity|string|Amount|
|side|int|Direction，1 buy，-1 sell|
|status|int|Status  2 Outstanding，3 Partial filled，4 all filled，5 cancel after partial filled，6 all cancel|
|symbol|string|Pair|
|timestamp|int|Time to fill ms|
|trade_no|string|Trade serial number|
|match_qty|string|Filled quantity|
|match_price|string|Average transaction price|


# Basic information

## All trading pairs
This portal will respond all pairs ByTrade support

```shell
Spot

"https://spot.bytrade.io/open/v1/tickers"

```

### HTTP query
Spot
- GET ` /open/v1/tickers`

<aside class="notice">Rate limit 1r/s</aside>

### Request parameters
|Field name|Data Type|Required|Description|
|:---:|:---:|:---:|:---:|
|symbol|string|no|Pair|

> Responds:

```json
{  
    'code': 0, 
    'data': [
            {'amount': '1.586',
            'change': '-0.235462',
            'high': '3.05',
            'low': '3.05',
            'price': '0',
            'symbol': 'BTT-USDT',
            'amt_num': 4,
            'qty_num': 2,
            'volume': '0.52'
            }, 
        ]
}
```

### Response Content

|Field name|Data Type|Description|
|:-----:|:------:|:----:|
|amount|string|24h amount|
|change|string|24h change|
|high|string|24h high|
|low|string|24h low|
|price|string|Current price|
|symbol|string|Pair|
|amt_num|integer|Price precision|
|qty_num|integer|Amount precision|
|volume|string|24h volume|

## Account balance

```shell
Spot

"https://spot.bytrade.io/open/v1/balance"

```

### HTTP query
Spot
- GET ` /open/v1/balance`

### Request parameters
None

> Responds:

```json
{
    'code': 0, 
    'data': [
        {
            'amount': '4317.6696678', 
            'symbol': "USDT", 
            'freeze': '71.609185'
        },
    ]
}
```

### Response Content

|Field name|Data Type|Description|
|:-----:|:------:|:----:|
|amount|string|Available balance|
|symbol|string|Coin|
|freeze|string|Locked balance|

## Server time stamp

```shell
Spot

"https://spot.bytrade.io/open/v1/timestamp"

```

### HTTP query
Spot
- GET ` /open/v1/timestamp`


### Request parameters
This portal not receive any parameter
> Responds:

```json
{
    "code": 0,
    "msg": "ok",
    "data": "12354534",
}
```

### Response Content

|Field name|Data Type|Description|
|:-----:|:------:|:----:|
|data|string|time stamp|


# Market Information

## Market K line

```shell
Spot

"https://spot.bytrade.io/open/v1/kline"

```

### HTTP query
Spot
- GET ` /open/v1/kline`

<aside class="notice">Rate limit 0.1r/s</aside>

### Request parameters
|Field name|Data Type|Required|            Description             |
|:---:|:---:|:---:|:----------------------------------:|
|symbol|string|yes|         Pair e.g: BTT-USDT         |
|type|string|yes| Type e.g: 1Min, 5Min, 15Min, 30Min |

> Responds:

```json
{
    'code': 0, 
    'data': [
        {
            'amount': '0',
            'close': '3.05',    
            'high': '3.05', 
            'low': '3.05', 
            'open': '3.05', 
            'time': 1571812440, 
            'volume': '0'
        }
    ]
}
```

### Response Content

|Field name|Data Type|Description|
|:-----:|:------:|:----:|
|amount|string|Volume|
|close|string|Local close price|
|high|string|Local highest price |
|low|string|Local lowest price|
|open|string|Local open price
|time|integer|Time|
|volume|string|Volume|

## Market depth

```shell
Spot

"https://spot.bytrade.io/open/v1/depth"

```

### HTTP query
Spot
- GET ` /open/v1/depth`

<aside class="notice">Rate limit 10r/s</aside>

### Request parameters
|Field name|Data Type|Required|Description|
|:---:|:---:|:---:|:---:|
|symbol|string|yes|Pair|

> Responds:

```json
{
    'code': 0, 
    'data': {
        'bids': [
            {'price': '2.923', 'quantity': '12'}, 
            {'price': '2.823', 'quantity': '12'}, 
            {'price': '2.813', 'quantity': '14'}
        ], 
        'asks': [
            {'price': '3.05', 'quantity': '3.48'}, 
            {'price': '3.31', 'quantity': '15'}, 
            {'price': '3.923', 'quantity': '15'}
            ]
        }, 
    'msg': 'ok'
}
```

### Response Content

|Field name|Data Type|Description|
|:-----:|:------:|:----:|
|bids|object|Current all buy orders[{price, quantity}]|
|asks|object|Current all sell orders[{price, quantity}]|


## Get last 5 trade orders

```shell
Spot

"https://spot.bytrade.io/open/v1/tickers/trade"

```

### HTTP query
Spot
- GET ` /open/v1/tickers/trade`

<aside class="notice">Rate limit 10r/s</aside>

### Request parameters
|Field name|Data Type|Required|Description|
|:---:|:---:|:---:|:---:|
|symbol|string|yes|Pair|

> Responds:

```json
{
    'code': 0, 
    'data': [{
        'amount': '0.918',
        'price': '2.04',
        'side': -1,
        'time': 1574942822160,
        'volume': '0.45'
        }]
}
```

### Response Content

|Field name|Data Type|Description|
|:-----:|:------:|:----:|
|amount|string|Volume|
|price|string|Price|
|side|integer|Direction，1 buy，-1 sell|
|time|integer|Time|
|volume|string|Volume|


# Market Data

## Place new order

```shell
Spot

"https://spot.bytrade.io/open/v1/orders/place"

```

### HTTP query
Spot
- POST ` /open/v1/orders/place`

### Request parameters(form-data parameters)
|Field name|Data Type|Required|Description|
|:---:|:---:|:---:|:---:|
|symbol|string|yes|Pair|
|price|string|no|price, if order type is LIMIT,Required|
|quantity|string|yes|quantity|
|side|int|yes|Direction, 1 buy, -1 sell|
|order_type|string|no|Direction, limit(default), market|

<aside class="warning">For both buy and sell, quantity represents trading coin, such as BTT of BTT-USDT</aside>
<aside class="warning">The first order of the new trading pair in the spot must be placed through this interface, and users can place the order after the trading is completed.</aside>

> Responds:

```json
{
    "code": 0,
    "msg": "ok",
    "data": {
        "order_id": "xxx",
        "trade_no": "xxx",
    },
}
```

### Response Content

|Field name|Data Type|Description|
|:-----:|:------:|:----:|
|order_id|string|Order placing number|
|trade_no|string|Trade serial number|


## Cancel an order in order

```shell
Spot

"https://spot.bytrade.io/open/v1/orders/cancel"

```

### HTTP query
Spot
- POST ` /open/v1/orders/cancel`

### Request parameters
|Field name|Data Type|Required|Description|
|:---:|:---:|:---:|:---:|
|symbol|string|yes|Pair|
|order_id|string|yes|Order placing number|
|trade_no|string|yes|Trade serial number|

> Responds:

```json
{
    "code": 0,
    "msg": "ok",
}
```

### Response Content

|Field name|Data Type|Description|
|:-----:|:------:|:----:|
This portal not receive any parameter

## Cancel all or part of the orders in order

```shell
Spot

"https://spot.bytrade.io/open/v1/orders/batcancel"

```

### HTTP query
Spot
- POST ` /open/v1/orders/batcancel`

<aside class="notice">Rate limit 1r/s</aside>

### Request parameters
|Field name|Data Type|Required|Description|
|:---:|:---:|:---:|:---:|
|symbol|string|yes|Pair|
|order_ids|string|no|Trading pair id, 1000, 2000, 3000, comma-separated order id, empty all cancel orders|

> Responds:

```json
{
    "code": 0,
    "msg": "ok",
}
```

### Response Content

|Field name|Data Type|Description|
|:-----:|:------:|:----:|
This portal not receive any parameter

## Active orders

```shell
Spot

"https://spot.bytrade.io/open/v1/orders/last"

```

### HTTP query
Spot
- GET ` /open/v1/orders/last`

### Request parameters
|Field name|Data Type|Required|Description|
|:---:|:---:|:---:|:---:|
|symbol|string|yes|Pair|

> Responds:

```json
{
    'code': 0, 
    'data': [
        {
            'symbol': 'BTT-USDT',
            'order_id': '11574744030837944',
            'trade_no': '499016576021202015341',
            'price': '7900',
            'quantity': '1',
            'match_amt': '0',
            'match_qty': '0',
            'match_price': '',
            'side': -1,
            'order_type': 1,
            'create_at': 1574744151836
        }, 
    ], 
}
```

### Response Content

|Field name|Data Type|Description|
|:-----:|:------:|:----:|
|symbol|string|Pair
|order_id|string|Order ID|
|trade_no|string|Trade serial number|
|price|string|price|
|quantity|string|Amount|
|match_amt|string|Filled amount|
|match_qty|string|Filled quantity|
|match_price|string|Average price|
|side|int|Direction，1 buy，-1 sell|
|order_type|int|order_type, 1 Limit，3 Market|
|create_at|int|Create time|

## Order history

```shell
Spot

"https://spot.bytrade.io/open/v1/orders"

```

### HTTP query
Spot
- GET ` /open/v1/orders`

<aside class="notice">Rate limit 0.5r/s</aside>

### Request parameters
|Field name|Data Type|Required|              Description              |
|:---:|:---:|:---:|:-------------------------------------:|
|symbol|string|yes|           Pair e.g: BTT-USDT            |
|pagenum|int|no|                 Page                  |
|pagesize|int|no| Page size, default 20, min 10, max 50 |
|side|int|no|     Direction，1 buy，-1 sell，0 all     |
|start|int|no|       Starting time, time stamp       |
|end|int|no|       Closing time, time stamp        |

> Responds:

```json
{
    'code': 0, 
    'msg': 'ok',
    'data': {
        'count': 4, 
        'orders': [
            {
                'order_id': '11574744030837944',
                'trade_no': '499016576021202015341',
                'symbol': 'BTT-USDT',
                'price': '7900',
                'quantity': '1',
                'match_amt': '0',
                'match_qty': '0',
                'match_price': '',
                'side': -1,
                'order_type': 1,
                'status': 6,
                'create_at': 1574744151836
            }, 
        ]
    }, 
}
```

### Response Content

|Field name|Data Type|Description|
|:-----:|:------:|:----:|
|order_id|string|Order id|
|trade_no|string|Trade serial number|
|symbol|string|Pair|
|price|string|Price|
|quantity|string|Quantity|
|match_amt|string|Filled amount|
|match_qty|string|Filled quantity|
|match_price|string|Average price|
|side|int|Direction，1 buy，-1 sell|
|order_type|int|order_type, 1 Limit，3 Market|
|status|int|Status  2 Outstanding，3 Partial filled，4 all filled，5 cancel after partial filled，6 all cancel|
|create_at|int|Created Time|

## Get order details

```shell
Spot

"https://spot.bytrade.io/open/v1/orders/detail"

```

### HTTP query
Spot
- GET ` /open/v1/orders/detail`

<aside class="notice">Rate limit 6r/s</aside>

### Request parameters
|Field name|Data Type|Required|    Description    |
|:---:|:---:|:---:|:-----------------:|
|symbol|string|yes| Pair e.g:BTT-USDT |
|order_id|string|yes|     Order id      |

> Responds:

```json
{
    'code': 0, 
    'data': {
        'order_id': '11574751725833010',
        'trade_no': '499073202290421221116', 
        'symbol': 'BTT-USDT', 
        'price': '70000', 
        'quantity': '0.0001', 
        'match_amt': '7', 
        'match_qty': '0.0001',
        'match_price': '70000',  
        'fee': '0.0112',
        'side': -1, 
        'order_type': 1,
        'status': 4,
        'create_at': 1574922846832,
        'trades': [{
            'amount': '7', 
            'price': '70000', 
            'quantity': '0.0001',
            'fee': '0.0112',  
            'time': 1574922846833
            }]
    }
}
```

### Response Content

|Field name|Data Type|Description|
|:-----:|:------:|:----:|
|order_id|string|Order id|
|trade_no|string|Trade serial number|
|symbol|string|Pair|
|price|string|Price|
|quantity|string|Amount|
|match_amt|string|Filled amount|
|match_qty|string|Filled quantity|
|match_price|string|Average price|
|fee|string|fee|
|side|int|Direction，1 buy，-1 sell|
|order_type|int|order_type, 1 Limit，3 Market|
|status|int|Status  2 Outstanding，3 Partial filled，4 all filled，5 cancel after partial filled，6 all cancel|
|create_at|int|Order creation time|
|trades|object|Filled order data[{|
|trade_id|string|trade id|
|amount|string|Amount of every filled order|
|price|string|Price of every filled order|
|quantity|string|quantity of every filled order|
|fee|string|Fee of every filled order|
|time|int|Time of every filled order}]|

## Paging to get order details

```shell
Spot

"https://spot.bytrade.io/open/v1/orders/detailmore"

```

### HTTP query
Spot
- GET ` /open/v1/orders/detailmore`

<aside class="notice">Rate limit 6r/s</aside>

### Request parameters
|Field name|Data Type|Required|              Description              |
|:---:|:---:|:---:|:-------------------------------------:|
|symbol|string|yes|           Pair e.g:BTT-USDT           |
|pagenum|int|no|                 Page                  |
|pagesize|int|no| Page size, default 10, min 10, max 50 |

> Responds:

```json
{
    'code': 0, 
    'data': {
        'count': 10,
        'trades': [
            {
              'amount': '11574751725833010',
              'fee': '499073202290421221116',
              'symbol': 'BTT-USDT',
              'price': '70000',
              'quantity': '0.0001',
              'side': '7',
              'time': 1574922846833,
              'trade_id': 1,
            }
          ]
    }
}
```

### Response Content

|Field name|Data Type|Description|
|:-----:|:------:|:----:|
|count|int|quantity of order|
|trades|object|Filled order data[{|
|symbol|string|Pair|
|side|int|Direction，1 buy，-1 sell|
|trade_id|int|trade id|
|amount|string|Amount of every filled order|
|price|string|Price of every filled order|
|quantity|string|quantity of every filled order|
|fee|string|Fee of every filled order|
|time|int|Time of every filled order}]|

## 	Get the user's transaction fee for a certain transaction pair

```shell
Spot

"https://spot.bytrade.io/open/v1/fee-rate"

```

### HTTP query
Spot
- GET ` /open/v1/fee-rate`

### Request parameters
|Field name|Data Type|Required|    Description     |
|:---:|:---:|:---:|:------------------:|
|symbol|string|yes| Pair e.g: BTT-USDT |

> Responds:

```json
{
    'code': 0, 
    'data': {
        'maker_fee': '0.0001',
        'taker_fee': "0.0002"
    }
}
```

### Response Content

|Field name|Data Type|Description|
|:-----:|:------:|:----:|
|maker_fee|string|maker fee|
|taker_fee|string|taker fee|


# Public API

## All trading pairs

```shell
Spot

"https://spot.bytrade.io/open/v1/tickers/market"

```

### HTTP query
Spot
- GET ` /open/v1/tickers/market`

<aside class="notice">Rate limit 6r/s</aside>

### Request parameters
|Field name|Data Type|Required|Description|
|:---:|:---:|:---:|:---:|

> Responds:

```json
{  
    'code': 0, 
    'data': [
            {'amount': '1.586',
            'change': '-0.235462',
            'high': '3.05',
            'low': '3.05',
            'price': '0',
            'symbol': 'BTT-USDT',
            'amt_num': 4,
            'qty_num': 2,
            'volume': '0.52'
            }, 
        ]
}
```

### Response Content

|Field name|Data Type|Description|
|:-----:|:------:|:----:|
|amount|string|24h volume|
|change|string|24h change|
|high|string|24h high|
|low|string|24h low|
|price|string|Current price|
|symbol|string|Pair|
|amt_num|integer|Price precision|
|qty_num|integer|Amount precision|
|volume|string|24h volume|

## Depth

```shell
Spot

"https://spot.bytrade.io/open/v1/depth/market"

```

### HTTP query
Spot
- GET ` /open/v1/depth/market`

<aside class="notice">Rate limit 5r/s</aside>

### Request parameters
|Field name|Data Type|Required|    Description     |
|:---:|:---:|:---:|:------------------:
|symbol|string|yes| Pair e.g: BTT-USDT |

> Responds:

```json
{
    'code': 0, 
    'data': {
        'bids': [
            {'price': '2.923', 'quantity': '12'}, 
            {'price': '2.823', 'quantity': '12'}, 
            {'price': '2.813', 'quantity': '14'}
        ], 
        'asks': [
            {'price': '3.05', 'quantity': '3.48'}, 
            {'price': '3.31', 'quantity': '15'}, 
            {'price': '3.923', 'quantity': '15'}
            ]
        }, 
    'msg': 'ok'
}
```

### Response Content

|Field name|Data Type|Description|
|:-----:|:------:|:----:|
|bids|object|Current all buy orders[{price, quantity}]|
|asks|object|Current all sell orders[{price, quantity}]|

## Each filled orders

```shell
Spot

"https://spot.bytrade/open/v1/trade/market"

```

### HTTP query
Spot
- GET ` /open/v1/trade/market`

<aside class="notice">Rate limit 10r/s</aside>

### Request parameters
|Field name|Data Type|Required|    Description     |
|:---:|:---:|:---:|:------------------:|
|symbol|string|yes| Pair e.g: BTT-USDT |

> Responds:

```json
{
    'code': 0, 
    'data': [{
        'amount': '0.918',
        'price': '2.04',
        'side': -1,
        'time': 1574942822160,
        'volume': '0.45'
        }]
}
```

### Response Content

|Field name|Data Type|Description|
|:-----:|:------:|:----:|
|amount|string|Volume|
|price|string|Price|
|side|integer|Direction，1 buy，-1 sell|
|time|integer|Time|
|volume|string|Volume|

<aside class="notice">Rate limit 1r/s</aside>

## Market K line

```shell
Spot

"https://spot.bytrade.io/open/v1/kline/market"

```

### HTTP query
Spot
- GET ` /open/v1/kline/market`

### Request parameters
|Field name|Data Type|Required|            Description             |
|:---:|:---:|:---:|:----------------------------------:|
|symbol|string|yes|         Pair e.g: BTT-USDT         |
|type|string|yes| Type e.g: 1Min, 5Min, 15Min, 30Min |

> Responds:

```json
{
    'code': 0, 
    'data': [
        {
            'amount': '0',
            'close': '3.05',    
            'high': '3.05', 
            'low': '3.05', 
            'open': '3.05', 
            'time': 1571812440, 
            'volume': '0'
        }
    ]
}
```

### Response Content

|Field name|Data Type|Description|
|:-----:|:------:|:----:|
|amount|string|Volume|
|close|string|Local close price|
|high|string|Local highest price |
|low|string|Local lowest price|
|open|string|Local open price
|time|integer|Time|
|volume|string|Volume|

# API Example

> Python:

```python
# -*- coding:utf-8 -*-

import requests
import time
import hmac
import hashlib
import ujson
import random


host = "https://spot.bytrade.io"
client_id = ""
client_key = ""

def gen_sign(client_id, client_key):
    ts = int(time.time())
    nonce = "abcdefg"
    obj = {"ts": ts, "nonce": nonce, "sign": "", "client_id": client_id}
    s = "client_id=%s&nonce=%s&ts=%s" % (client_id, nonce, ts) 
    v = hmac.new(client_key.encode(), s.encode(), digestmod=hashlib.sha256)
    obj["sign"] = v.hexdigest()
    return obj 

print("> Active orders")
# Spot
path = "/open/v1/orders/last"
obj = gen_sign(client_id, client_key)
obj.update({"symbol": "ETH-USDT"})
res = requests.get(host + path, params=obj)
print(ujson.loads(res.content))

print("> Get an order details")
# Spot
path = "/open/v1/orders/detail"
obj = gen_sign(client_id, client_key)
obj.update({"order_id": "11574751725833010", "symbol": "BTT-USDT"})
res = requests.get(host + path, params=obj)
print(ujson.loads(res.content))

print("> Paging to get order details")
# Spot
path = "/open/v1/orders/detailmore"
obj = gen_sign(client_id, client_key)
obj.update({"symbol": "BTT-USDT", "pagesize": 10, "pagenum": 1"})
res = requests.get(host + path, params=obj)
print(ujson.loads(res.content))

print("> Get the user's transaction fee for a certain transaction pair")
# Spot
path = "/open/v1/orders/fee-rate"
obj = gen_sign(client_id, client_key)
obj.update({"symbol": "BTT-USDT"})
res = requests.get(host + path, params=obj)
print(ujson.loads(res.content))

print("> Market K line")
# Spot
path = "/open/v1/kline"
obj = gen_sign(client_id, client_key)
obj.update({"symbol": "BTT-USDT", "type": "1Min"})
res = requests.get(host + path, params=obj)
print(ujson.loads(res.content))

print("> Account balance")
# Spot
path = "/open/v1/balance"
obj = gen_sign(client_id, client_key)
res = requests.get(host + path, params=obj)
print(ujson.loads(res.content))

print("> Get last 5 trade orders")
# Spot
path = "/open/v1/tickers/trade"
obj = gen_sign(client_id, client_key)
obj.update({"symbol": "BTT-USDT"})
res = requests.get(host + path, params=obj)
print(ujson.loads(res.content))

print("> Place new order")
# Spot
path = "/open/v1/orders/place"
obj = gen_sign(client_id, client_key)
obj.update({"symbol": "BTT-USDT", "price": "8850.21", "quantity": "0.1", "side": "1", "order_type": "LIMIT"})
res = requests.post(host + path, data=obj)
print(ujson.loads(res.content))
```


# Websocket Example

> Python:

```python
# -*- coding:utf-8 -*-

import time
import hmac
import hashlib
import websockets
import json
import asyncio
import uvloop

asyncio.set_event_loop_policy(uvloop.EventLoopPolicy())

# Spot
host = "wss://spot.bytrade.io/ws"
client_id = ""
client_key = ""

def login():
    ts = int(time.time())
    nonce = "abcdefg"
    obj = {"ts": ts, "nonce": nonce, "sign": "", "client_id": client_id, "op": "apilogin"}
    s = "client_id=%s&nonce=%s&ts=%s" % (client_id, nonce, ts)
    v = hmac.new(client_key.encode(), s.encode(), digestmod=hashlib.sha256)
    obj["sign"] = v.hexdigest()
    return obj

async def sub_topic(ws):
    sub = "depth:0:BTT-USDT"
    await ws.send(json.dumps({"op": "sub", "topic": sub}))

async def startup():
    print("start to connect %s..." % host)
    ws = await websockets.connect(host)

    obj = login()
    await ws.send(json.dumps(obj))
    await sub_topic(ws)

    while 1:
        try:
            data = await ws.recv()
            print(data)
        except websockets.exceptions.ConnectionClosed as e:
            print("connect closed...", e)
            return
        except:
            pass

if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    loop.run_until_complete(startup())

```
