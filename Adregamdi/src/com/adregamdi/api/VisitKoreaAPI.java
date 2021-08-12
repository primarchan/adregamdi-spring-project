package com.adregamdi.api;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import com.adregamdi.dto.SpotDTO;
import com.adregamdi.dto.VisitKoreaDTO;


@Service
public class VisitKoreaAPI {
	//final String serviceKey = "JfJVEeeIonh3aWVPoAYN0TNONgdW1JYIJGc3vQrNtsia5qmmOdoEmVgTXQjgkCC4wYqdEXhDdG6Q6HnCH01fww%3D%3D";
	final String serviceKey = "qnCiac2R%2FyDsI9qIRqZ8fYyyptvK%2FW%2F5hLtuE7CrNIoMLR1gJtqlIa0VbbYvYGhAVCOnheRCj2NsHdX2H58Y0g%3D%3D";
	//final String serviceKey = "VacIglqrkZWUmOB%2Fj3T5GH2f%2BzGHYDoVxCK7ZAd4rjFI7yFptSwKUX%2BQWF0abo%2FCqOJQW6JbM83IE5Ry55QO7A%3D%3D";
	//final String serviceKey = "Smzhs16%2BToWtT1PvYihg48fomJ6J9OEs3LAsF0KolSdPioT%2FxVGkOKouPuhGdWIdducYehyL2T9XC2bvnEDV0Q%3D%3D";
	//final String serviceKey = "rW8xQWWEtsVq3gxRs6WbPsAm3K5ifzEyxT67BoZn94XFj5KPOT0C0TcLpifB18t%2Blcz4ANQooKbGI6j2Chcp%2BQ%3D%3D";
	//final String serviceKey = "1Pu4UXuCj88qEZ2m7lWAsNCj4FcA8nhUutYQlXwqrnKRQiB5cuYHPlvedpq%2B0uoo8%2FuZ0TqCSiMtt0BA51OWNA%3D%3D";
	
  // T map API ( 占쏙옙占� : http://tmapapi.sktelecom.com/index.html )
	final String tmapKey = "l7xxdc109d32e488487dbf0e29b9dfcf1a59";
	
	public static String getTagValue(String tag, Element element) {
		try {
			NodeList nodeList = element.getElementsByTagName(tag).item(0).getChildNodes();
			Node value = (Node) nodeList.item(0);
			if (value == null) {
				return null;
			}
			return value.getNodeValue();
		} catch (NullPointerException e) {
			return null;
		}
	}

	// 설정한 개수만큼 contentId List를 가져옴
	public ArrayList<String> getContentIdList(String pageNo, String sigunguCode, String contentTypeId, String numOfRow)
			throws SAXException, IOException, ParserConfigurationException {
		String url = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/areaBasedList?" + "serviceKey="
				+ serviceKey + "&pageNo=" + pageNo + "&numOfRows=" + numOfRow + "&MobileOS=ETC" + "&MobileApp=AppTest"
				+ "&arrange=P" + "&cat1=" + "&contentTypeId=" + contentTypeId + "&areaCode=39" + "&sigunguCode="
				+ sigunguCode + "&cat2=" + "&cat3=" + "&listYN=Y" + "&modifiedtime=";

		// XML Parsing
		DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder documentBuilder = documentBuilderFactory.newDocumentBuilder();
		Document document = documentBuilder.parse(url);

		document.getDocumentElement().normalize();

		NodeList nodeList = document.getElementsByTagName("item");

		ArrayList<String> contentIdList = new ArrayList<String>();

		for (int i = 0; i < nodeList.getLength(); i++) {
			Node node = nodeList.item(i);
			if (node.getNodeType() == Node.ELEMENT_NODE) {
				Element element = (Element) node;
				contentIdList.add(getTagValue("contentid", element));
			}
		}
		return contentIdList;
	}
	
	public VisitKoreaDTO getOneSpot(String contentId) throws ParserConfigurationException, SAXException, IOException {
		VisitKoreaDTO spot = new VisitKoreaDTO();
		
		String url = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/detailCommon?" + "serviceKey="
				+ serviceKey + "&numOfRows=1" + "&pageNo=1" + "&MobileOS=ETC" + "&MobileApp=AppTest"
				+ "&areacodeYN=Y" + "&catcodeYN=Y" + "&addrinfoYN=Y" + "&contentId=" + contentId
				+ "&contentTypeId=" + "&defaultYN=Y" + "&firstImageYN=Y" + "&mapinfoYN=Y" + "&overviewYN=Y";
		// XML Parsing
		DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder documentBuilder = documentBuilderFactory.newDocumentBuilder();
		Document document = documentBuilder.parse(url);

		document.getDocumentElement().normalize();

		NodeList nodeList = document.getElementsByTagName("item");
		
		for (int i = 0; i < nodeList.getLength(); i++) {
			Node node = nodeList.item(i);
			
			if (node.getNodeType() == Node.ELEMENT_NODE) {
				Element element = (Element) node;
				if (getTagValue("firstimage", element) == null) {
					spot.setFirstImage("/images/schedule/thumbnail.png");
				} else {
					spot.setFirstImage(getTagValue("firstimage", element));
				}
				
				if (getTagValue("firstimage2", element) == null) {
					spot.setFirstImage2("/images/schedule/thumbnail.jpg");
				} else {
					spot.setFirstImage2(getTagValue("firstimage2", element));
				}
				spot.setTitle(getTagValue("title", element));
				if (getTagValue("addr1", element) == null) {
					spot.setAddr1("해당 여행지는 코스이므로 주소가 없습니다.");
				} else {
					spot.setAddr1(getTagValue("addr1", element));
				}
				spot.setOverview(getTagValue("overview", element));
				spot.setContentId(getTagValue("contentid", element));
				spot.setContentTypeId(getTagValue("contenttypeid", element));
			}
		}
		return spot;
	}
	

	// Spot의 정보를 가져옴
	public ArrayList<NodeList> getSpotInfo(ArrayList<String> contentIdList)
			throws ParserConfigurationException, SAXException, IOException {
		ArrayList<NodeList> infoList = new ArrayList<NodeList>();
		
		for (int i = 0; i < contentIdList.size(); i++) {
			String url = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/detailCommon?" + "serviceKey="
					+ serviceKey + "&numOfRows=1" + "&pageNo=1" + "&MobileOS=ETC" + "&MobileApp=AppTest"
					+ "&areacodeYN=Y" + "&catcodeYN=Y" + "&addrinfoYN=Y" + "&contentId=" + contentIdList.get(i)
					+ "&contentTypeId=" + "&defaultYN=Y" + "&firstImageYN=Y" + "&mapinfoYN=Y" + "&overviewYN=Y";

			// XML Parsing
			DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder documentBuilder = documentBuilderFactory.newDocumentBuilder();
			Document document = documentBuilder.parse(url);

			document.getDocumentElement().normalize();

			NodeList nodeList = document.getElementsByTagName("item");
			infoList.add(nodeList);
		}
		return infoList;
	}

	// VisitKorea 占쏙옙占쏙옙占쏙옙占� 占쏙옙占쏙옙占쏙옙占쏙옙占쏙옙회 (TotalCount)
	public int getTotalCount(String contentTypeId, String sigunguCode)
			throws ParserConfigurationException, SAXException, IOException {
		String url = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/areaBasedList?" + "serviceKey="
				+ serviceKey + "&MobileApp=AppTest" + "&MobileOS=ETC" + "&contentTypeId=" + contentTypeId
				+ "&areaCode=39" + "&sigunguCode=" + sigunguCode + "&listYN=N";

		// XML Parsing
		DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder documentBuilder = documentBuilderFactory.newDocumentBuilder();
		Document document = documentBuilder.parse(url);

		document.getDocumentElement().normalize();

		NodeList nodeList = document.getElementsByTagName("item");

		ArrayList<Integer> contentIdList = new ArrayList<Integer>();

		for (int i = 0; i < nodeList.getLength(); i++) {
			Node node = nodeList.item(i);
			if (node.getNodeType() == Node.ELEMENT_NODE) {
				Element element = (Element) node;
				contentIdList.add(Integer.parseInt(getTagValue("totalCnt", element)));
			}
		}
		return contentIdList.get(0);
	}

	// 일괄적으로 contentId를 저장함.
	public ArrayList<String> lgetContentId() throws SAXException, IOException, ParserConfigurationException {
		
		ArrayList<String> contentIdList = getContentIdList("1", "", "", String.valueOf(getTotalCount("","")));
		
		return contentIdList;
	}
	
	// BestTop �젙蹂� ���옣
	public List<VisitKoreaDTO> getBestInformation(VisitKoreaDTO visitKoreaDTO,  ArrayList<String> bestContentIdList)
			throws SAXException, IOException, ParserConfigurationException {
		
		// 怨듯넻 �젙蹂� 議고쉶s
		ArrayList<NodeList> spotInfo = getSpotInfo(bestContentIdList);
		List<VisitKoreaDTO> bestInformation = new ArrayList<VisitKoreaDTO>();
		
		for(int c = 0; c < bestContentIdList.size(); c++) {
			for (int i = 0; i < spotInfo.size(); i++) {
				VisitKoreaDTO spot = new VisitKoreaDTO();
				
				for (int j = 0; j < spotInfo.get(i).getLength(); j++) {
					Node node = spotInfo.get(i).item(j);
					
					if (node.getNodeType() == Node.ELEMENT_NODE) {
						Element element = (Element) node;
						
						
						if (getTagValue("firstimage", element) == null) {
							spot.setFirstImage("/images/schedule/thumbnail.png");
						} else {
							spot.setFirstImage(getTagValue("firstimage", element));
						}
						
						if (getTagValue("firstimage2", element) == null) {
							spot.setFirstImage2("/images/schedule/thumbnail.jpg");
						} else {
							spot.setFirstImage2(getTagValue("firstimage2", element));
						}
						
						spot.setTitle(getTagValue("title", element));
						if (!visitKoreaDTO.getContentTypeId().equals("25")) {
							spot.setAddr1(getTagValue("addr1", element));
						}
						spot.setOverview(getTagValue("overview", element));
						spot.setContentId(getTagValue("contentid", element));
						spot.setContentTypeId(getTagValue("contenttypeid", element));
					}
				}
				
				String spotContentId = spot.getContentId();
				String bestContentId = bestContentIdList.get(c);
					
				if(spotContentId.equals(bestContentId)) {
					bestInformation.add(spot); 
				}
			}
		}
		return bestInformation;
	}
	
	// 媛쒕왂�쟻�씤 �젙蹂�?
	public List<VisitKoreaDTO> getInformation(VisitKoreaDTO visitKoreaDTO, int totalCount)
			throws SAXException, IOException, ParserConfigurationException {
		// id留� ���옣
		ArrayList<String> contentIdList = getContentIdList(visitKoreaDTO.getPageNo(), visitKoreaDTO.getSigunguCode(), visitKoreaDTO.getContentTypeId(), visitKoreaDTO.getNumOfRow());
		// 怨듯넻 �젙蹂� 議고쉶
		ArrayList<NodeList> spotInfo = getSpotInfo(contentIdList);
		List<VisitKoreaDTO> information = new ArrayList<VisitKoreaDTO>();
		for (int i = 0; i < spotInfo.size(); i++) {
			VisitKoreaDTO spot = new VisitKoreaDTO();
			for (int j = 0; j < spotInfo.get(i).getLength(); j++) {
				Node node = spotInfo.get(i).item(j);
				if (node.getNodeType() == Node.ELEMENT_NODE) {
					Element element = (Element) node;
					if (getTagValue("firstimage", element) == null) {
						spot.setFirstImage("/images/schedule/thumbnail.jpg");
					} else {
						spot.setFirstImage(getTagValue("firstimage", element));
					}
					if (getTagValue("firstimage2", element) == null) {
						spot.setFirstImage2("/images/schedule/thumbnail.jpg");
					} else {
						spot.setFirstImage2(getTagValue("firstimage2", element));
					}
					spot.setTitle(getTagValue("title", element));
					if (!visitKoreaDTO.getContentTypeId().equals("25")) {
						spot.setAddr1(getTagValue("addr1", element));
					}
					spot.setOverview(getTagValue("overview", element));
					spot.setContentId(getTagValue("contentid", element));
					spot.setContentTypeId(getTagValue("contenttypeid", element));
					spot.setMapX(getTagValue("mapx", element));
					spot.setMapY(getTagValue("mapy", element));
					spot.setTotalCount(Integer.toString(totalCount));
					
				}
			}
			
			information.add(spot);
		}

		return information;
	}
	
	// like 추가한 내용 가져오기
	public List<VisitKoreaDTO> getInformationPlusLike(VisitKoreaDTO visitKoreaDTO, ArrayList<SpotDTO> spotDTO, int totalCount)
			throws SAXException, IOException, ParserConfigurationException {
		
		// 9개씩 id 값 가져오기
		ArrayList<String> contentIdList = getContentIdList(visitKoreaDTO.getPageNo(), visitKoreaDTO.getSigunguCode(), visitKoreaDTO.getContentTypeId(), visitKoreaDTO.getNumOfRow());
				
		// 해당 아이디의 값으로 Spot별 내용 가져오기
		ArrayList<NodeList> spotInfo = getSpotInfo(contentIdList);
		List<VisitKoreaDTO> information = new ArrayList<VisitKoreaDTO>();
		
		for (int i = 0; i < spotInfo.size(); i++) {
			VisitKoreaDTO spot = new VisitKoreaDTO();
			int searchIdx = (Integer.parseInt(visitKoreaDTO.getPageNo()) -1 ) * 9 + i;
			
			spot.setLike_cnt(spotDTO.get(searchIdx).getLike_cnt());
			spot.setReview_cnt(spotDTO.get(searchIdx).getReview_cnt());
			for (int j = 0; j < spotInfo.get(i).getLength(); j++) {
				Node node = spotInfo.get(i).item(j);
				if (node.getNodeType() == Node.ELEMENT_NODE) {
					Element element = (Element) node;
					if (getTagValue("firstimage2", element) == null) {
						spot.setFirstImage("/images/schedule/thumbnail.png");
					} else {
						spot.setFirstImage(getTagValue("firstimage", element));
					}
					spot.setTitle(getTagValue("title", element));
					if (!visitKoreaDTO.getContentTypeId().equals("25")) {
						spot.setAddr1(getTagValue("addr1", element));
					}
					spot.setOverview(getTagValue("overview", element));
					spot.setContentId(getTagValue("contentid", element));
					spot.setContentTypeId(getTagValue("contenttypeid", element));
					spot.setMapX(getTagValue("mapx", element));
					spot.setMapY(getTagValue("mapy", element));
					spot.setTotalCount(Integer.toString(totalCount));
				}
			}
			information.add(spot);
		}
		return information;
	}
	
	// 상세정보 가져오기
	public List<String> getEachInformation(VisitKoreaDTO visitKoreaDTO) throws Exception {
		List<String> information = new ArrayList<String>();
		information = getCommonInfo(visitKoreaDTO.getContentId(), visitKoreaDTO.getContentTypeId(), information);
		information = getIntroduceInfo(visitKoreaDTO.getContentId(), visitKoreaDTO.getContentTypeId(), information);

		return information;
	}

	// 공통정보 가져오기
	public List<String> getCommonInfo(String contentId, String contentTypeId, List<String> information)
			throws Exception {
		String url = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/detailCommon?" + "serviceKey="
				+ serviceKey + "&numOfRows=1" + "&pageNo=1" + "&MobileOS=ETC" + "&MobileApp=AppTest" + "&contentId="
				+ contentId + "&contentTypeId=" + contentTypeId + "&defaultYN=Y" + "&firstImageYN=Y" + "&areacodeYN=Y"
				+ "&catcodeYN=Y" + "&addrinfoYN=Y" + "&mapinfoYN=Y" + "&overviewYN=Y&";

		DocumentBuilderFactory dbFactoty = DocumentBuilderFactory.newInstance();
		DocumentBuilder dBuilder = dbFactoty.newDocumentBuilder();
		Document doc = dBuilder.parse(url);

		// root tag
		doc.getDocumentElement().normalize();
		
		// 占식쏙옙占쏙옙 tag
		NodeList nList = doc.getElementsByTagName("item");
		for (int i = 0; i < nList.getLength(); i++) {
			Node node = nList.item(i);
			if (node.getNodeType() == Node.ELEMENT_NODE) {
				Element element = (Element) node;
				if (getTagValue("firstimage", element) == null)
					information.add("/resources/assets/img/spot_images/no_img.png");
				else
					information.add(getTagValue("firstimage", element));
				information.add(getTagValue("title", element));
				information.add(getTagValue("overview", element));
				information.add(getTagValue("addr1", element));
				information.add(getTagValue("mapy", element));
				information.add(getTagValue("mapx", element));
			}
		}
		return information;
	}

	// 상세정보 가져오기
	public List<String> getIntroduceInfo(String contentId, String contentTypeId, List<String> information)
			throws Exception {
		String url = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/detailIntro?" + "serviceKey="
				+ serviceKey + "&numOfRows=1" + "&pageNo=1" + "&MobileOS=ETC" + "&MobileApp=AppTest" + "&contentId="
				+ contentId + "&contentTypeId=" + contentTypeId + "&";

		DocumentBuilderFactory dbFactoty = DocumentBuilderFactory.newInstance();
		DocumentBuilder dBuilder = dbFactoty.newDocumentBuilder();
		Document doc = dBuilder.parse(url);
		// root tag
		doc.getDocumentElement().normalize();
		

		NodeList nList = doc.getElementsByTagName("item");
		switch (contentTypeId) {
		case "12":
			for (int i = 0; i < nList.getLength(); i++) {
				Node node = nList.item(i);
				if (node.getNodeType() == Node.ELEMENT_NODE) {
					Element element = (Element) node;
					information.add(getTagValue("infocenter", element));
					information.add(getTagValue("restdate", element));
					information.add(getTagValue("usetime", element));
				}
			}
			break;
		case "14":
			for (int i = 0; i < nList.getLength(); i++) {
				Node node = nList.item(i);
				if (node.getNodeType() == Node.ELEMENT_NODE) {
					Element element = (Element) node;
					information.add(getTagValue("infocenterculture", element));
					information.add(getTagValue("usefee", element));
					information.add(getTagValue("usetimeculture", element));
				}
			}
			break;
		case "15":
			for (int i = 0; i < nList.getLength(); i++) {
				Node node = nList.item(i);
				if (node.getNodeType() == Node.ELEMENT_NODE) {
					Element element = (Element) node;
					information.add(getTagValue("eventhompage", element));
					information.add(getTagValue("sponsor1tel", element));
					information.add(getTagValue("playtime", element));
					information.add(getTagValue("usetimefestival", element));
				}
			}
			break;
		case "25":
			for (int i = 0; i < nList.getLength(); i++) {
				Node node = nList.item(i);
				if (node.getNodeType() == Node.ELEMENT_NODE) {
					Element element = (Element) node;
					information.add(getTagValue("infocentertourcourse", element));
					information.add(getTagValue("taketime", element));
					information.add(getTagValue("theme", element));
				}
			}
			break;
		case "28":
			for (int i = 0; i < nList.getLength(); i++) {
				Node node = nList.item(i);
				if (node.getNodeType() == Node.ELEMENT_NODE) {
					Element element = (Element) node;
					information.add(getTagValue("infocenterleports", element));
					information.add(getTagValue("restdateleports", element));
					information.add(getTagValue("usefeeleports", element));
					information.add(getTagValue("usetimeleports", element));
				}
			}
			break;
		case "32":
			for (int i = 0; i < nList.getLength(); i++) {
				Node node = nList.item(i);
				if (node.getNodeType() == Node.ELEMENT_NODE) {
					Element element = (Element) node;
					information.add(getTagValue("checkintime", element));
					information.add(getTagValue("checkouttime", element));
					information.add(getTagValue("infocenterlodging", element));
					information.add(getTagValue("reservationurl", element));
					information.add(getTagValue("reservationlodging", element));
				}
			}
			break;
		case "38":
			for (int i = 0; i < nList.getLength(); i++) {
				Node node = nList.item(i);
				if (node.getNodeType() == Node.ELEMENT_NODE) {
					Element element = (Element) node;
					information.add(getTagValue("infocentershopping", element));
					information.add(getTagValue("opentime", element));
					information.add(getTagValue("restdateshopping", element));
				}
			}
			break;
		case "39":
			for (int i = 0; i < nList.getLength(); i++) {
				Node node = nList.item(i);
				if (node.getNodeType() == Node.ELEMENT_NODE) {
					Element element = (Element) node;
					information.add(getTagValue("firstmenu", element));
					information.add(getTagValue("infocenterfood", element));
					information.add(getTagValue("opentimefood", element));
					information.add(getTagValue("restdatefood", element));
				}
			}
			break;
		}
		return information;
	}

	// 키워드 ..
	public List<VisitKoreaDTO> getKeywordInformation(VisitKoreaDTO visitKoreaDTO, String keyword) throws ParserConfigurationException, SAXException, IOException, InterruptedException {
		String encodeKeyword = URLEncoder.encode(keyword, "UTF-8");
		String url = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/searchKeyword?" 
					+ "serviceKey=" + serviceKey 
					+ "&MobileApp=AppTest" 
					+ "&MobileOS=ETC" 
					+ "&pageNo=" + visitKoreaDTO.getPageNo()
					+ "&numOfRows=" + visitKoreaDTO.getNumOfRow() 
					+ "&listYN=Y" 
					+ "&arrange=P" 
					+ "&contentTypeId="
					+ "&areaCode=39" 
					+ "&sigunguCode=" 
					+ "&cat1=" 
					+ "&cat2=" 
					+ "&cat3=" 
					+ "&keyword=" + encodeKeyword;

		// XML Parsing
		DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder documentBuilder = documentBuilderFactory.newDocumentBuilder();
		Document document = documentBuilder.parse(url);

		document.getDocumentElement().normalize();

		NodeList nodeList = document.getElementsByTagName("item");
		ArrayList<String> contentIdList = new ArrayList<String>();
		for (int i = 0; i < nodeList.getLength(); i++) {
			Node node = nodeList.item(i);
			if (node.getNodeType() == Node.ELEMENT_NODE) {
				Element element = (Element) node;
				contentIdList.add(getTagValue("contentid", element));
			}
		}

		String totalCount = "";
		nodeList = document.getElementsByTagName("totalCount");
		Node countNode = nodeList.item(0);
		if (countNode.getNodeType() == Node.ELEMENT_NODE) {
			Element element = (Element) countNode;
			totalCount = getTagValue("totalCount", element);
		}

		ArrayList<NodeList> spotInfo = getSpotInfo(contentIdList);
		List<VisitKoreaDTO> result = new ArrayList<VisitKoreaDTO>();
		for (int i = 0; i < spotInfo.size(); i++) {
			VisitKoreaDTO spot = new VisitKoreaDTO();
			for (int j = 0; j < spotInfo.get(i).getLength(); j++) {
				Node infoNode = spotInfo.get(i).item(j);
				if (infoNode.getNodeType() == Node.ELEMENT_NODE) {
					Element element = (Element) infoNode;
					if (getTagValue("firstimage", element) == null) {
						spot.setFirstImage("/images/spot/jeju.jpg");
					} else {
						spot.setFirstImage(getTagValue("firstimage", element));
					}

					if (getTagValue("firstimage2", element) == null) {
						spot.setFirstImage2("/images/schedule/thumbnail.jpg");
					} else {
						spot.setFirstImage2(getTagValue("firstimage2", element));
					}
					
					spot.setTitle(getTagValue("title", element));
					
					if (!visitKoreaDTO.getContentTypeId().equals("25")) {
						spot.setAddr1(getTagValue("addr1", element));
					}
					
					spot.setOverview(getTagValue("overview", element));
					spot.setContentId(getTagValue("contentid", element));
					spot.setContentTypeId(getTagValue("contenttypeid", element));
					spot.setTotalCount(totalCount);
				}
			}
			result.add(spot);
		}
		return result;
	}
}
	