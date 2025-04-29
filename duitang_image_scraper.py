import re
import requests
from bs4 import BeautifulSoup

user_agents = [
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36',
    'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1'
]

headers = {
    'User-Agent': random.choice(user_agents)
}

def get_valid_images(url, min_size=300):
    params = {
        'include_fields': 'like_count,sender,album,msg,reply_count,top_comments',
        'kw': '头像',
        'start': 0
    }
    
    valid_urls = []
    try:
        response = requests.get(url, headers=headers, params=params)
        data = response.json()
        
        for item in data.get('data', {}).get('list', []):
            photo = item.get('photo', {})
            img_url = photo.get('path', '')
            
            # 优先使用API原始尺寸
            original_width = photo.get('width', 0)
            original_height = photo.get('height', 0)
            
            # 备用方案：OSS元数据查询
            if original_width <= 0 or original_height <= 0:
                try:
                    # 获取原始图片元数据
                    clean_url = img_url.split('?')[0]
                    meta = requests.head(clean_url, headers=headers, timeout=3)
                    original_width = int(meta.headers.get('x-oss-meta-width', 0))
                    original_height = int(meta.headers.get('x-oss-meta-height', 0))
                except Exception as meta_error:
                    pass
            
            if original_width >= min_size and original_height >= min_size:
                valid_urls.append(clean_url)
                
    except Exception as e:
        print(f'API请求失败: {e}')
    
    return valid_urls

def main():
    api_url = 'https://www.duitang.com/napi/blog/list/by_search/'
    collected = []
    start = 0
    batch_size = 24  # 每批返回数量
    
    while len(collected) < 50 and start <= 200:
        try:
            urls = get_valid_images(current_url, params={'start': start})
            if not urls:
                print('没有更多数据，停止抓取')
                break
            collected = list({url for url in collected + urls})[:50]  # 去重并限制数量
            print(f'本批获取到{len(urls)}条，累计{len(collected)}条')
            start += batch_size
            time.sleep(random.uniform(1.5, 3))
        except Exception as e:
            print(f'抓取失败: {e}')
            break
            urls = get_valid_images(current_url)
            if not urls:
                print('未找到有效图片，停止抓取')
                break
            collected.extend(urls[:50-len(collected)])
            page += 1
            time.sleep(random.uniform(1, 3))
        except Exception as e:
            print(f'抓取失败: {e}')
            break
    
    with open('image_urls.txt', 'w') as f:
        f.write('\n'.join(collected[:50]))
    print(f'成功保存{len(collected[:50])}条有效图片地址')

if __name__ == '__main__':
    main()

    # ./venv/bin/python3 gaoding_image_scraper.py