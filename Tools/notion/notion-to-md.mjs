import { Client } from '@notionhq/client';
import { NotionConverter } from 'notion-to-md';
import { DefaultExporter } from 'notion-to-md/plugins/exporter';
import { MDXRenderer } from 'notion-to-md/plugins/renderer';
import * as path from 'path';
import 'dotenv/config';
import { exit } from 'node:process';

const apiKey = process.env.NOTION_INTEGRATION_SECRET;
const serverBaseImagesUrl = process.env.SERVER_BASE_IMAGES_URL;
const pageId = process.argv[2]
if (pageId === undefined) {
  console.error("pageId가 필요합니다")
  exit(128)
}

const notion = new Client({
  auth: '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',
});

async function convertPage() {
  try {
    const exporter = new DefaultExporter({
      outputType: 'file',
      outputPath: `./extract/${pageId}.md`
    });

    const renderer = new MDXRenderer({
      frontmatter: {
        include: ['title']
      }
    });

    const n2m = new NotionConverter(notion)
      .downloadMediaTo({
        outputDir: './extract/images',
        transformPath: (localPath) => `${serverBaseImagesUrl}/${path.basename(localPath)}`
      })
      .withExporter(exporter)
      .withRenderer(renderer);
    
    await n2m.convert(pageId);
    console.log('✓ Successfully converted page to markdown!');
  } catch (error) {
    console.error('Conversion failed:', error);
  }
}

convertPage();
