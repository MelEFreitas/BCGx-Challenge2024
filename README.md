# GAIA
<img align="left" src="frontend/assets/logo.png" alt="BedTime logo" width="200" height="133">
GAIA,derived from _Gestão Ambiental com Inteligência Artificial_, is a cutting-edge Generative AI tool specializing in the climate and environmental landscape of Brazil. ts mission is to empower citizens with accessible knowledge of the latest laws and regulations regarding Brazil's climate and environment, regardless of their level of expertise. Leveraging over 1,500 pages of official documents, GAIA is designed to assist users in several key areas:

- **Understanding Climate and Environmental Topics:** GAIA provides insights into various climate-related subjects, curiosities, and facts to enhance users’ awareness and knowledge.
-  **Guidance for Public Managers:** Local government officials can utilize GAIA to learn how to adapt their towns and cities to comply with current regulations and strategic plans, ensuring sustainable development within their communities.
- **In-Depth Research Support:** Environmental specialists and researchers can receive detailed explanations and analyses of environmental plans, helping them navigate complex information and enhance their studies.

Whether you are a curious citizen, a public manager striving for compliance, or a researcher seeking comprehensive insights, GAIA is here to support your journey toward a better understanding of Brazil's environmental landscape.

## How it works?
GAIA is much more than just a Generative AI; it is a comprehensive system designed to meet users' needs effectively. Here’s a brief overview of its functionality:

1. **Content Preparation:** The process begins with the cleaning and refinement of documents, extracting only useful and essential information. This ensures that users receive relevant insights without unnecessary clutter.
2. **Embedding Process:** The refined texts and images undergo a transformation known as Embedding. During this process, human-readable information—such as words, paragraphs, titles, and images—is converted into vectors. These vectors classify the information based on various criteria, allowing GAIA to efficiently identify the most relevant answers to your queries.
3. **Vector Storage:** The resulting vectors are stored in a specialized Vector Database, which is optimized for this type of information storage and retrieval.
4. **User Interaction:** When a user sends a message, it is also embedded into a vector format. This vector is then compared to the document vectors to determine similarity—words with similar meanings will appear "closer" in this vector space.
5. **Answer Retrieval:** GAIA utilizes a Large Language Model (LLM), specifically OpenAI's GPT-4 model, to find answers within the official documents. This ensures that the responses are grounded in verified sources, minimizing the risk of inaccurate information or "hallucinations."

Through this intricate process, GAIA provides users with accurate, relevant, and reliable answers to their questions about Brazil’s climate and environmental regulations.

## Usage
To get started with GAIA, clone this repository and navigate to the project directory:
```
cd BCGx-Challenge2024
```

All necessary services for GAIA's operation can be initialized using Docker. Run the following command to build and start the services:
```
docker compose up --build
```

Please wait for the images to be fetched and the containers to be built. This process should take approximately 3–4 minutes due to the frontend service relying on Flutter and its SDK. Once the process is complete, you can access GAIA by navigating to `http://localhost:3000` in your web browser. We recommend using Google Chrome, as the project has been primarily tested in this environment.

## Documentation
This section provides a detailed technical explanation of the services, technologies, and architecture that comprise GAIA's system design.

### Software Engineering Aspects
GAIA utilizes a microservices architecture, which is crucial for ensuring scalability, flexibility, and maintainability. This approach allows the system to decompose complex functionalities into smaller, independent services that can be developed, deployed, and scaled individually. Following this paradigm, GAIA is composed of three primary services:

- **Frontend:** The frontend is developed in Flutter and serves as the user interface (UI) layer. It abstracts some of the logic involved in the interaction between users and the language model (LLM). You can explore the frontend code in the `frontend/` folder.
- **Backend:** The backend is implemented in Python and handles the core business logic of the project. This includes tasks such as user account creation, prompt generation, and fetching responses from the LLM. The backend code can be found in the `backend/` folder.
- **Database:** The database utilizes relational features (SQL) to store data that supports the application’s functionality. It employs the PostgreSQL database management system to establish relationships between stored data, ensuring an optimal user experience.

All these services are instantiated using Docker containers. The file `docker-compose.yml` contains the instructions that Docker must follow to initialize this application. In the following sections, we will delve deeper into each of these services, providing a comprehensive understanding of their roles and interactions within the GAIA system.

#### Frontend
The frontend service leverages Flutter's widgets to create a seamless interaction between the user and the LLM. The UI is designed to be simple, useful, and organized, empowering users to have full control over the customization of their profiles and messages. The most relevant screens are:

- **Sign Up:** Users can enter their email, password, and choose between roles to create an account on GAIA.
- **Sign In:** Users can input their credentials to access the application.
- **Auth:** The frontend handles the submission of authentication tokens to verify the user's identity without the need to input their credentials for every interaction.
- **Home:** This is where users can interact with the LLM through a chat, view past chats, and start new conversations.

This service leverages two major packages to provide this experience: [BLoC](https://pub.dev/packages/flutter_bloc) and [Dio](https://pub.dev/packages/dio). The BLoC (Business Logic Component) package is responsible for managing the state of the UI and acts directly in the presentation layer. Instead of a global state, each component/widget has its own state and behaves accordingly. Specifically, GAIA uses Cubits to handle state: they are similar to Blocs, with the difference that the former controls state through functions, while the latter does so through events. The Cubits are responsible for several actions in the UI, including:

- Displaying errors upon unsuccessful requests.
- Changing the screen according to the user authentication status.
- Starting animations during loading periods.
- Reflecting changes during a conversation in a chat with the AI.

The Cubits are defined at `frontend/lib/presentation/<screen_name>/cubits`. Moreover, developing the frontend in Flutter makes it easy to add features like a splash screen and to make the UI responsive (try resizing the screen).

On the other hand, Dio operates in the data layer, orchestrating the frontend's interaction with the backend. This is done via the HTTP protocol: actions on the UI result in HTTP requests, which are processed by the backend and culminate in a response sent back to the frontend. These responses can either be successful or not; Dio determines that responses with a 2XX HTTP Status Code are successful, while those with 4XX and 5XX are not. Dio also handles the building of the HTTP headers necessary for some operations. For example, when authenticating, the user must provide the JWT Access Token, which requires an HTTP `Authorization: Bearer YOUR_ACCESS_TOKEN`. Speaking of tokens, GAIA stores the access and refresh tokens locally in the browser using the [SharedPreferences](https://pub.dev/packages/shared_preferences) package; more on this later.

The Dio requests are defined at `frontend/lib/data/sources/<layer_name>`.

#### Backend
The backend service utilizes the FastAPI framework to provide an API that adheres to REST principles. This service was designed to contain single-purpose routes with defined objectives, which the UI can request to receive the desired response. It is composed of several major parts:

- **Routes:** These are the API endpoints to which the frontend makes requests. For example, a GET request with a query parameter of `chat_id` to the URL `http://localhost/chats/{chat_id}` will retrieve information about the chat that has `id == chat_id`.
- **Schemas:** These determine the data models from the Pydantic library used in processing requests and responses. This allows the backend to perform data validation on incoming data, rejecting unwanted formats instead of processing unvalidated data and risking undefined behavior.
- **Database Models:** The SQLAlchemy library provides models to define and manage the information stored in the tables in the PostgreSQL database. It also enables the definition of queries to retrieve the data stored in that database. For instance, GAIA defines that each user must have an `id` of type UUID. This `id` serves as their Primary Key, distinguishing one user from another. In the chats table, we store the user ID that owns that chat as a Foreign Key. This way, when trying to retrieve the content of a chat, the backend service can fetch only the chats that belong to the user.
- **CRUD:** The backend API follows CRUD principles, where the operations performed in the API have a single defined purpose.

In order for the backend to perform operations, the user must authenticate themselves. GAIA leverages the JWT (JSON Web Tokens) authentication mechanism to provide stateless authentication. Upon signing in, the user is provided with two JWT tokens: an access token, which lasts a couple of minutes, and a refresh token, which lasts for days. Using tokens allows the frontend to avoid having to provide the user's credentials (email and password) for every request. For example, if the authentication mechanism relied on sessions, allowing a user to update a chat would require the backend to fetch their session from a cache, which can be slow if multiple API instances are trying to read from and write to the cache. By using JWT, GAIA can determine the authenticity of a request mathematically by decoding the token. If the access token is expired, the frontend can provide the refresh token to obtain a new access token, avoiding the need to re-enter credentials.

## Next Steps
Concerning the security aspect of GAIA, there is certainly room for improvement. For instance, all communication between the services utilizes the HTTP protocol. When sending their access token in the headers, the token is not encrypted; thus, an attacker could perform a man-in-the-middle attack and steal the user's token. Moreover, the token is not stored with encryption in the browser, which is also a vulnerability.

Concerning the scalability aspect, if multiple users make requests to the backend API, some may take more time to execute than others. Instead of having to wait for the OpenAI API to reply with an answer, GAIA could leverage an asynchronous message broker to manage queues of messages sent between the user and the backend API, and between the backend API and the OpenAI APIs. This would make the backend less idle and certainly improve the overall experience when using GAIA.
