 #!/usr/bin/python
import json
import sys
import logging
import rds_config
import psycopg2
import config
import boto3
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)

try:
    conn = psycopg2.connect(database="logistics",
                        host="blau-production.cvcvpaamxkwo.us-east-2.rds.amazonaws.com",
                        user="is44c",
                        password="5o1zJIIcUVCylbt9c0k6k1n2rRCEOJ",
                        port="5432")
except:
    logger.error("ERROR: Unexpected error: Could not connect to PGSQL instance.")
    sys.exit()
    logger.info("SUCCESS: Connection to RDS mysql instance succeeded")

def lambda_handler(event, context):
    sql_query = """select id_truck ,st_flipcoordinates(position :: geometry), registered_at at time zone 'utc' AT TIME ZONE 'cdt' as dates
                from tbl_gps_data tgd
                where registered_at at time zone 'utc' AT TIME ZONE 'cdt' >= '2022-09-28 18:00:00' 
                and registered_at at time zone 'utc' AT TIME ZONE 'cdt' <= '2022-09-28 21:18:00' 
                and id_truck = 73"""
    cur = conn.cursor()
    cur.execute(sql_query)
    output = cur.fetchall()
    print(output)
    return {
    'result':json.dumps(output),
    'statusCode': 200,
    'body': json.dumps('Hello from Lambda!')
    }

