import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin

headers = {
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Safari/605.1.15'
}

def scrape_images(url):
    try:
        response = requests.get(url, headers=headers, timeout=10)
        response.raise_for_status()
        
        soup = BeautifulSoup(response.text, 'html.parser')
        images = []
        
        for picture in soup.find_all(['picture', 'img']):
            # 优先解析source标签
            sources = picture.find_all('source') or [picture]
            best_src = None
            
            for source in sources:
                # 优先选择webp格式的高清图
                srcset = source.get('srcset') or source.get('data-srcset')
                if srcset:
                    # 提取最高分辨率链接（2x）
                    urls = [u.split()[0] for u in srcset.split(',') if '2x' in u]
                    if urls:
                        best_src = urls[-1]
                        break
                    
                # 备用方案：普通src属性
                src = source.get('src') or source.get('data-src')
                if src:
                    best_src = src
                    break
            
            if not best_src:
                continue
                
            full_url = urljoin(url, best_src)
            
            # 获取真实图片尺寸
            try:
                # 发送HEAD请求获取图片元数据
                img_res = requests.head(full_url, headers=headers, timeout=5, allow_redirects=True)
                if 'image' in img_res.headers.get('Content-Type', ''):
                    width = int(img_res.headers.get('X-Image-Width', 0))
                    height = int(img_res.headers.get('X-Image-Height', 0))
                else:
                    # 备用方案：使用URL参数推断
                    import re
                    size_match = re.search(r'/(\d+)x(\d+)/', full_url)
                    if size_match:
                        width, height = map(int, size_match.groups())
                    else:
                        width = height = 0
            except Exception as e:
                print(f'尺寸获取失败: {e}')
                width = height = 0
            
            # 调试日志
            print(f'候选图片: {full_url}')
            print(f'解析尺寸: {width}x{height} (来自: {"headers" if width>0 else "URL匹配"})')
            
            if width > 300 and height > 300:
                images.append({
                    'url': full_url,
                    'width': width,
                    'height': height
                })
                
                # 达到20张立即返回
                if len(images) >= 20:
                    break
        
        return images[:20]
        
    except Exception as e:
        print(f'抓取失败: {e}')
        return []

if __name__ == '__main__':
    target_url = 'https://www.gaoding.com/scenes/laodongjiechangjing-page-1?fid=6266457-a6266468_1000002024'
    result = scrape_images(target_url)
    
    print(f'找到{len(result)}张符合要求的图片：')
    for i, img in enumerate(result, 1):
        print(f'{i}. {img["url"]} ({img["width"]}x{img["height"]})')